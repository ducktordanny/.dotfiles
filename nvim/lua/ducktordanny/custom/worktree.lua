local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local themes = require 'telescope.themes'

local auto_session = require 'auto-session'
local nvim_tree_api = require 'nvim-tree.api'

local get_worktree_paths = function()
  local project_path = vim.fn.getcwd()
  local worktrees = vim.fn.systemlist 'git worktree list'

  local tree_paths = {}
  local bare_path = ''

  for _, worktree in ipairs(worktrees) do
    local info = {}
    for match in worktree:gmatch '%S+' do
      table.insert(info, match)
    end
    if info[1] ~= project_path and info[2] ~= '(bare)' then
      table.insert(tree_paths, info[1])
    elseif info[2] == '(bare)' then
      bare_path = info[1]
    end
  end

  local current_tree = '-'
  if project_path ~= bare_path and bare_path ~= '' then
    current_tree = project_path:sub(#bare_path + 2)
  end

  return { tree_paths = tree_paths, bare_path = bare_path, current_tree = current_tree }
end

local get_tree_names = function(tree_paths, bare_path)
  local tree_names = {}

  for _, path in ipairs(tree_paths) do
    local name = path:sub(#bare_path + 2)
    table.insert(tree_names, name)
  end

  return tree_names
end

local handle_worktree_switch = function(tree_path)
  local project_path = vim.fn.getcwd()

  vim.cmd ':wa'
  vim.cmd ':LspStop'
  auto_session.SaveSession(project_path)
  vim.cmd ':%bd'
  nvim_tree_api.tree.change_root(tree_path)
  auto_session.RestoreSession(tree_path)
  vim.cmd ':LspStart'
end

local open_worktree_window = function(opts)
  opts = opts or {}
  local trees = get_worktree_paths()
  local tree_names = get_tree_names(trees.tree_paths, trees.bare_path)

  pickers
    .new(opts, {
      prompt_title = 'Worktrees (' .. trees.current_tree .. ')',
      finder = finders.new_table {
        results = tree_names,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          handle_worktree_switch(trees.tree_paths[selection.index])
        end)
        return true
      end,
    })
    :find()
end

local select_worktree = function()
  open_worktree_window(themes.get_dropdown {})
end

vim.keymap.set('n', '<leader>si', select_worktree, { desc = 'Select work tree' })
