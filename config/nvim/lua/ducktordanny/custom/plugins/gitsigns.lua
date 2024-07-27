vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[G]it [U]ndo hunk" })
vim.keymap.set("v", "ga", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage selected hunk" })
vim.keymap.set("v", "gr", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage for selected hunk" })
