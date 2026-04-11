local map = vim.keymap.set

-- Disable space in normal/visual so leader works unambiguously
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- `x` shouldn't clobber the unnamed register
map("n", "x", '"_x')

-- Tabs
map("n", "<leader>t", ":tabnew .<cr>", { desc = "New tab (cwd)" })
map("n", "<leader>tt", ":tabnew %<cr>", { desc = "New tab (current buffer)" })

-- Move selection up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without clobbering register
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- Replace word under cursor project-wide in current buffer
map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word under cursor",
})
map("n", "<leader>rr", [[:%s/\(<C-r>*\)/\1]], { desc = "Extend yank parts" })

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Diagnostics
map("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, { desc = "Next diagnostic" })
map("n", "<leader>E", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Better visual indent (stay in visual)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search highlight
map("n", "<leader>sn", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Black hole delete
map("n", "<leader>d", '"_d', { desc = "Black hole delete" })

-- Quickfix navigation
map("n", "<leader>j", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "<leader>k", "<cmd>cprev<cr>", { desc = "Prev quickfix item" })

-- LSP restarts
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP: Restart" })
map("n", "<leader>lR", "<cmd>TSToolsRestartServer<cr>", { desc = "TSTools: Restart server" })

-- Fun
map("n", "<leader>ll", "<cmd>!fortune | cowsay -f tux<cr>", { desc = "Cowsay a fortune" })

-- Terminal: escape to normal
map("t", "<Esc>", "<C-\\><C-N>", { desc = "Terminal -> Normal mode" })

-- System clipboard yanks
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map("i", "<C-p>", "<Esc>pa", { desc = "Paste from register in insert" })

-- Window/split resize (Alt + hjkl)
map("n", "<A-j>", "5<C-w>-", { desc = "Decrease height" })
map("n", "<A-k>", "5<C-w>+", { desc = "Increase height" })
map("n", "<A-h>", "5<C-w><", { desc = "Decrease width" })
map("n", "<A-l>", "5<C-w>>", { desc = "Increase width" })
map("n", "<A-u>", "<C-w>=", { desc = "Equalize splits" })

-- Insert lines and stay in normal
map("n", "<leader>o", "o<Esc>", { desc = "Open line below (stay normal)" })
map("n", "<leader>O", "O<Esc>", { desc = "Open line above (stay normal)" })

-- Toggle relativenumber across all windows (for screen shares)
map("n", "<leader>rj", function()
  vim.o.relativenumber = not vim.o.relativenumber
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win].relativenumber = vim.o.relativenumber
  end
end, { desc = "Toggle relativenumbers" })

-- Apply dotfiles config command
vim.api.nvim_create_user_command("ApplyDotfilesConfigs", function()
  vim.cmd(":!bash " .. vim.fn.expand "$HOME/.config/.dotfiles/setup/apply-config.sh")
end, {})
