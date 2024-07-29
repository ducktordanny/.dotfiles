local Path = require "plenary.path"

local M = {}

M._session_files_path = vim.fn.expand "$HOME/.local/share/nvim/sessions/"

M._handle_not_existing_path = function()
  local path = Path:new(M._session_files_path)
  local path_exists = path:exists()
  if path_exists then
    return
  end
  path:mkdir()
end

M.create_session = function()
  M._handle_not_existing_path()
  local cwd = vim.fn.getcwd()
  local session_file_name = vim.base64.encode(cwd)
  vim.cmd("mks! " .. M._session_files_path .. session_file_name)
end

M.restore_session = function()
  local cwd = vim.fn.getcwd()
  local session_file_name = vim.base64.encode(cwd)
  local path = Path:new(M._session_files_path .. session_file_name)
  local file_exists = path:exists()
  if not file_exists then
    return
  end
  vim.cmd("source " .. M._session_files_path .. session_file_name)
end

return M
