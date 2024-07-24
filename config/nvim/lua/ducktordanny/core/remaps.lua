-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "x", '"_x')

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

vim.keymap.set("n", "<leader>j", "<cmd>cnext<cr>", { desc = "Jump to next quick fix list item" })
vim.keymap.set("n", "<leader>k", "<cmd>cprev<cr>", { desc = "Jump to previous quick fix list item" })

-- Fun
vim.keymap.set("n", "<leader>ll", "<cmd>!fortune | cowsay -f tux<cr>", { desc = "Cowsay a fortune" })

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { desc = "Terminal mode to Normal mode" })

-- Yank magic
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("i", "<C-p>", "<Esc>pa")

-- resize thingies
vim.keymap.set("n", "<A-j>", "5<C-w>-", { desc = "Decrease height size by 5" })
vim.keymap.set("n", "<A-k>", "5<C-w>+", { desc = "Increase height size by 5" })
vim.keymap.set("n", "<A-h>", "5<C-w><", { desc = "Decrease width size by 5" })
vim.keymap.set("n", "<A-l>", "5<C-w>>", { desc = "Increase width size by 5" })
vim.keymap.set("n", "<A-u>", "<C-w>=", { desc = "Equalize width and height of all splits" })
