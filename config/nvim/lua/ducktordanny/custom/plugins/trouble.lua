vim.keymap.set("n", "<leader>ti", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>tI", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
