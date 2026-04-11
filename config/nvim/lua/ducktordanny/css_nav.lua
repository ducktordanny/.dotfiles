-- CSS class navigation between Angular templates and SCSS class definitions,
-- including resolution of SCSS `&` nested selectors. Wired up from plugins/lsp.lua.

local M = {}

local function trim(s)
  return s:match "^%s*(.-)%s*$"
end

-- SCSS `&foo` inherits the parent selector; everything else is literal.
local function resolve_amp(sel, parent)
  if sel:sub(1, 1) == "&" and parent ~= "" then
    return parent .. sel:sub(2)
  end
  return sel
end

-- Find the run of `pattern`-matching chars in `line` that contains `col`.
-- Returns `token, start_col` or nil if the cursor isn't inside such a run.
-- Uses Lua pattern position captures: `()` yields the current match offset,
-- so `"()<body>()"` hands us `(start, end + 1)` for each run.
local function token_around_cursor(line, col, pattern)
  for start, finish in line:gmatch("()" .. pattern .. "()") do
    if start <= col and col < finish then
      return line:sub(start, finish - 1), start
    end
  end
  return nil
end

-- `<cword>` doesn't include `-`, so `xyz-abc` comes back as `xyz`. Grab the
-- full identifier around the cursor, falling back to `<cword>` if there
-- isn't one (e.g. cursor on whitespace).
local function class_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  return token_around_cursor(line, col, "[%w_%-]+") or vim.fn.expand "<cword>"
end

-- Search the style file for a class definition, handling SCSS nesting with
-- `&` (e.g. `.xyz { &-abc { } }` defines `.xyz-abc`).
--
-- Two passes:
--   1. Literal `.class-name` match anywhere in the file (fast, covers plain
--      CSS and non-nested SCSS).
--   2. Brace-tracking SCSS walk that resolves `&` against the innermost
--      parent selector on each nesting level.
local function find_class(lines, target)
  local escaped = vim.pesc(target)
  local literal_dot = "%." .. escaped
  local pat_boundary = literal_dot .. "[%s,:{%%]"
  local pat_eol = literal_dot .. "$"
  for i, line in ipairs(lines) do
    if line:match(pat_boundary) or line:match(pat_eol) then
      return i, line:find(literal_dot) - 1
    end
  end

  local target_dot = "." .. target
  local stack = { "" }
  local pending, p_row, p_col = "", nil, nil
  local function reset()
    pending, p_row, p_col = "", nil, nil
  end

  -- At a `{`: if any comma-part of the pending selector resolves to the
  -- target, return the matched position. Otherwise push the first comma-part
  -- onto the scope stack for `&` resolution in children.
  local function enter_block(row, col)
    local parent = stack[#stack]
    local sel = trim(pending)
    for part in (sel .. ","):gmatch "([^,]+)," do
      if resolve_amp(trim(part), parent) == target_dot then
        return p_row or row, p_col or (col - 1)
      end
    end
    local first = trim(sel:match "^[^,]+" or "")
    -- at-rules (@media etc.) don't affect `&`; inherit parent scope.
    local pushed = first:sub(1, 1) == "@" and parent or resolve_amp(first, parent)
    table.insert(stack, pushed)
  end

  for row, raw in ipairs(lines) do
    local line = raw:gsub("//.-$", "") -- strip SCSS line comments
    for col = 1, #line do
      local c = line:sub(col, col)
      if c == "{" then
        local r, cc = enter_block(row, col)
        if r then
          return r, cc
        end
        reset()
      elseif c == "}" then
        if #stack > 1 then
          table.remove(stack)
        end
        reset()
      elseif c == ";" then
        reset()
      elseif pending == "" and c:match "%S" then
        p_row, p_col = row, col - 1
        pending = c
      else
        pending = pending .. c
      end
    end
    if pending ~= "" then
      pending = pending .. " "
    end
  end
end

-- Walk the buffer up to (stop_row, stop_col) collecting the enclosing SCSS
-- selector stack. Selectors are pushed unresolved — callers fold `&` later.
local function collect_selector_stack(buf_lines, stop_row, stop_col)
  local stack = {}
  local pending = ""
  for r, raw in ipairs(buf_lines) do
    if r > stop_row then
      break
    end
    local line = raw:gsub("//.-$", "")
    local limit = (r == stop_row) and stop_col or #line
    for c = 1, limit do
      local ch = line:sub(c, c)
      if ch == "{" then
        table.insert(stack, trim(pending:match "^[^,]+" or ""))
        pending = ""
      elseif ch == "}" then
        if #stack > 0 then
          table.remove(stack)
        end
        pending = ""
      elseif ch == ";" then
        pending = ""
      else
        pending = pending .. ch
      end
    end
    pending = pending .. " "
  end
  return stack
end

-- Fold a selector stack left-to-right, resolving each `&` against its parent.
local function fold_stack(stack)
  local resolved = ""
  for _, sel in ipairs(stack) do
    if sel:sub(1, 1) == "@" then
      -- at-rule: doesn't participate in the selector chain
    elseif sel:sub(1, 1) == "&" and resolved ~= "" then
      resolved = resolved .. sel:sub(2)
    else
      resolved = sel
    end
  end
  return resolved
end

-- Grab the selector token at the cursor, including SCSS specials (`&`, `.`).
-- Returns `token, start_col` or nil if the cursor isn't on a selector char.
local function selector_token_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  return token_around_cursor(line, col, "[%w_%-&%.]+")
end

-- Resolve the class at the cursor in a style buffer: for `&foo` selectors,
-- prepend the folded enclosing selector chain so it matches what CSS sees.
local function resolve_class_at_cursor(bufnr)
  local token, token_start = selector_token_at_cursor()
  if not token then
    return nil
  end

  -- Plain selector: strip leading `.` if present and return as-is.
  if token:sub(1, 1) ~= "&" then
    return (token:sub(1, 1) == ".") and token:sub(2) or token
  end

  -- `&...`: walk up to the cursor, fold `&` left-to-right.
  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local stack = collect_selector_stack(buf_lines, cursor_row, token_start - 1)
  local resolved = fold_stack(stack)
  local parent = (resolved:sub(1, 1) == ".") and resolved:sub(2) or resolved
  return parent .. token:sub(2)
end

-- Find and read the co-located Angular component style file. Returns
-- (path, lines) or nil. Caches the resolved path on the html buffer.
local function resolve_component_style_file(bufnr)
  local cached = vim.b[bufnr].ducktordanny_component_style_file
  if cached then
    local ok, data = pcall(vim.fn.readfile, cached)
    if ok then
      return cached, data
    end
  end
  local html_file = vim.api.nvim_buf_get_name(bufnr)
  local base = html_file:gsub("%.component%.html$", ".component.")
  for _, ext in ipairs { "scss", "css" } do
    local path = base .. ext
    local ok, data = pcall(vim.fn.readfile, path)
    if ok then
      vim.b[bufnr].ducktordanny_component_style_file = path
      return path, data
    end
  end
end

-- `gdc` on an Angular component template: jump to the class definition in
-- the co-located `.component.{scss,css}` file.
function M.goto_component_class(bufnr)
  local class = class_under_cursor()
  local style_file, lines = resolve_component_style_file(bufnr)
  if not lines then
    vim.notify("No component style file found", vim.log.levels.WARN)
    return
  end
  local row, col = find_class(lines, class)
  if not row then
    vim.notify(
      "Class ." .. class .. " not found in " .. vim.fn.fnamemodify(style_file, ":t"),
      vim.log.levels.WARN
    )
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(style_file))
  vim.api.nvim_win_set_cursor(0, { row, col })
end

-- `gr` in a CSS/SCSS buffer: telescope grep_string for usages of the resolved
-- class under the cursor in html/template files.
function M.find_class_references(bufnr)
  local class = resolve_class_at_cursor(bufnr)
  if not class or class == "" then
    vim.notify("No CSS class under cursor", vim.log.levels.WARN)
    return
  end
  local ok_ts, tb = pcall(require, "telescope.builtin")
  if not ok_ts then
    vim.cmd("silent grep! " .. vim.fn.shellescape(class) .. " -- '*.html'")
    vim.cmd "copen"
    return
  end
  tb.grep_string {
    search = "\\b" .. class .. "\\b",
    use_regex = true,
    additional_args = function()
      return { "--glob", "*.html", "--glob", "*.htm", "--glob", "*.ts", "--glob", "*.tsx" }
    end,
    prompt_title = "References to ." .. class,
  }
end

return M
