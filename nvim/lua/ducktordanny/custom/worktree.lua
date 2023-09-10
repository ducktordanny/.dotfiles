local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local themes = require 'telescope.themes'

local auto_session = require 'auto-session'

local delete_opened_buffers = function()
  local all_buffers = vim.api.nvim_list_bufs()
  local project_path = vim.fn.getcwd()

  for _, bufnr in ipairs(all_buffers) do
    local buf_name = vim.fn.bufname(bufnr)

    if vim.fn.findfile(buf_name, project_path) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end

local get_filtered_trees = function()
  local project_path = vim.fn.getcwd()
  local worktrees = vim.fn.systemlist 'git worktree list'
  local output = {}

  for _, worktree in ipairs(worktrees) do
    local info = {}
    for match in worktree:gmatch '%S+' do
      table.insert(info, match)
    end
    if info[1] ~= project_path then
      table.insert(output, info[1])
    end
  end

  return output
end

local handle_worktree_switch = function()
  local project_path = vim.fn.getcwd()

  auto_session.SaveSession(project_path)
  delete_opened_buffers()
  local selection = action_state.get_selected_entry()
  if project_path == selection[1] then
    return
  end
  vim.cmd('cd ' .. selection[1])
  require('nvim-tree.api').tree.change_root(selection[1])
  auto_session.RestoreSession(selection[1])
end

local open_worktree_window = function(opts)
  opts = opts or {}
  local trees = get_filtered_trees()

  pickers
    .new(opts, {
      prompt_title = 'Worktrees',
      finder = finders.new_table {
        results = trees,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          handle_worktree_switch()
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
