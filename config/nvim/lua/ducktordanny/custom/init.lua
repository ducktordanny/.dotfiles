local worktree = require "ducktordanny.custom.worktree"
local td = require "ducktordanny.custom.td"

vim.keymap.set("n", "<leader>si", worktree.select_worktree_dropdown, { desc = "Select work tree" })
vim.keymap.set("n", "<leader>td", ":TdAdd ")
vim.api.nvim_create_user_command("TdAdd", td.add_local_todo, {})
vim.api.nvim_create_user_command("TdListUnresolved", td.show_unresolved_todos, {})
