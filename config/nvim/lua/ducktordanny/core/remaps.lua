-- Keymaps for better default experience

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Move around stuff here:
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Greates remap ever (according to ThePrimeagen)
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word that we are on",
})
vim.keymap.set("n", "<leader>rr", [[:%s/\(<C-r>*\)/\1]], { desc = "Extend yank parts" })

-- Better scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Better visual mode indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Remove search highlight
vim.keymap.set("n", "<leader>sn", "<cmd>noh<cr>", { desc = "Remove search highlight" })

-- Black hole delete
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Black hole delete (no save to regs)" })

vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open [e]xplorer with Explore" })
vim.keymap.set("n", "<leader>es", "<cmd>Sexplore<cr>", { desc = "Open [e]xplorer with [S]explore" })
vim.keymap.set("n", "<leader>ev", "<cmd>Vexplore<cr>", { desc = "Open [e]xplorer with [V]explore" })

vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  desc = "Better mappings for netrw",
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { remap = true, buffer = true })
    end

    bind("<C-l>", "<cmd>TmuxNavigateRight<cr>")
    bind("<c-h>", "<cmd>TmuxNavigateLeft<cr>")
  end,
})
