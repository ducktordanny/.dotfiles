local worktree = require "ducktordanny.custom.worktree"

vim.keymap.set("n", "<leader>si", worktree.select_worktree_dropdown, { desc = "Select work tree" })
