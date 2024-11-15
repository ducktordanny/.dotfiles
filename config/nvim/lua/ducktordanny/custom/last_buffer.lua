local Path = require "plenary.path"

local M = {}

---@class WorktreeConfigItem
---@field file string
---@field cursor_position number

---@alias WorktreeConfig table<string, WorktreeConfigItem>

M._config_file_path = vim.fn.expand "$HOME/.local/share/nvim/worktree.json"

---@return WorktreeConfig
M._get_config = function()
  local path = Path:new(M._config_file_path)
  local file_exists = path:exists()
  if not file_exists then
    return {}
  end
  local content = path:read()
  if content == "" or not vim.startswith(content, "{") then
    return {}
  end
  local config = vim.json.decode(content)
  return config
end

---@param config WorktreeConfig
M._set_config = function(config)
  local path = Path:new(M._config_file_path)
  local content = vim.json.encode(config)
  path:write(content, "w")
end

---@return WorktreeConfigItem | nil
M._get_current_buffer_details = function()
  -- TODO: gsub could be a variable, but rn idc
  local file = vim.api.nvim_buf_get_name(0):gsub("oil://", "")
  if not file or file == "" then
    return
  end
  local cursor_positions = vim.api.nvim_win_get_cursor(0)
  if vim.startswith(file, "fugitive") then
    local wins = vim.api.nvim_list_wins()
    if #wins == 1 then
      return
    end
    local current_win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_win_close(current_win_id, true)
    return M._get_current_buffer_details()
  end

  return {
    file = file,
    cursor_position = cursor_positions[1],
  }
end

M.save_for_current_cwd = function()
  local current_buffer_details = M._get_current_buffer_details()
  if not current_buffer_details then
    return
  end
  local config = M._get_config()
  local cwd = vim.fn.getcwd()
  config[cwd] = current_buffer_details
  M._set_config(config)
end

M.restore_by_cwd = function()
  local config = M._get_config()
  local cwd = vim.fn.getcwd()
  local restore_data = config[cwd]
  if not restore_data then
    vim.cmd("e .")
    return
  end
  if not restore_data.file then
    vim.cmd("e .")
    return
  end
  vim.cmd("e " .. restore_data.file)
  if not restore_data.cursor_position then
    return
  end
  local number_of_lines = vim.api.nvim_buf_line_count(0)
  if restore_data.cursor_position > number_of_lines then
    return
  end
  vim.api.nvim_win_set_cursor(0, { restore_data.cursor_position, 1 })
end

return M
