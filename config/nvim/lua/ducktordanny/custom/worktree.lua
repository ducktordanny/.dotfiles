local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"

local M = {}

M._get_worktree_paths = function()
  local project_path = vim.fn.getcwd()
  local worktrees = vim.fn.systemlist "git worktree list"

  local tree_paths = {}
  local bare_path = ""

  for _, worktree in ipairs(worktrees) do
    local info = {}
    for match in worktree:gmatch "%S+" do
      table.insert(info, match)
    end
    if info[1] ~= project_path and info[2] ~= "(bare)" then
      table.insert(tree_paths, info[1])
    elseif info[2] == "(bare)" then
      bare_path = info[1]
    end
  end

  local current_tree = "-"
  if project_path ~= bare_path and bare_path ~= "" then
    current_tree = project_path:sub(#bare_path + 2)
  end

  return { tree_paths = tree_paths, bare_path = bare_path, current_tree = current_tree }
end

M._get_tree_names = function(tree_paths, bare_path)
  local tree_names = {}

  for _, path in ipairs(tree_paths) do
    local name = path:sub(#bare_path + 2)
    table.insert(tree_names, name)
  end

  return tree_names
end

M._handle_worktree_switch = function(tree_path)
  vim.cmd ":wa"
  vim.cmd ":LspStop"
  vim.cmd ":SessionSave"
  vim.cmd ":%bd"
  vim.cmd("cd" .. tree_path)
  vim.cmd ":SessionRestore"
  vim.cmd ":LspStart"
end

M.select_worktree = function(opts)
  opts = opts or {}
  local trees = M._get_worktree_paths()
  local tree_names = M._get_tree_names(trees.tree_paths, trees.bare_path)

  pickers
    .new(opts, {
      prompt_title = "Worktrees (" .. trees.current_tree .. ")",
      finder = finders.new_table {
        results = tree_names,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M._handle_worktree_switch(trees.tree_paths[selection.index])
        end)
        return true
      end,
    })
    :find()
end

M.select_worktree_dropdown = function()
  M.select_worktree(themes.get_dropdown {})
end

return M
