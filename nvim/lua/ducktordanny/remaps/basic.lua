-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move around stuff here:
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- move around between splits better:
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>')
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>')

-- Greates remap ever (according to ThePrimeagen)
vim.keymap.set('x', '<leader>p', '"_dP')
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word that we are on' })

-- Better scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Undotree stuff
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = '[U]ndotree' })

-- Nvim Tree
vim.keymap.set('n', '<leader>nt', '<cmd>NvimTreeToggle<cr>', { desc = '[N]vimTree [T]oggle' })
vim.keymap.set('n', '<leader>ns', '<cmd>NvimTreeFindFile<cr>', { desc = '[N]vimTree [S]earch_file' })
vim.keymap.set('n', '<leader>nr', '<cmd>NvimTreeRefresh<cr>', { desc = '[N]vimTree [R]efresh' })

-- quick switch between buffers and close them etc
vim.keymap.set('n', '<leader>W', '<cmd>bp|bd #<cr>', { desc = 'Close current buffer window and open previous' })
vim.keymap.set('n', '<leader>WW', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers but this' })
vim.keymap.set('n', '<leader>WS', '<cmd>buffers<cr>:bd ', { desc = 'Select buffers to close' })

-- git, gitsigns and vgit remaps
vim.keymap.set('n', '<leader>gl', '<cmd>Flogsplit<cr>', { desc = '[G]it [L]og' })
vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns refresh<cr>', { desc = '[G]itsigns [R]efresh' })
vim.keymap.set('n', '<leader>ga', '<cmd>Git add --all<cr>', { desc = '[G]it add [a]ll' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit -m ""', { desc = '[G]it [C]ommit' })
vim.keymap.set('n', '<leader>gs', '<cmd>Git status<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push', { desc = '[G]it [P]ush' })
vim.keymap.set('n', '<leader>gf', '<cmd>Git fetch', { desc = '[G]it [F]etch' })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gd', '<cmd>VGit project_diff_preview<cr>', { desc = '[G]it [D]iff preview' })
vim.keymap.set('n', '<leader>l', '<cmd>LazyGit<cr>', { desc = '[L]azyGit' })
vim.keymap.set('n', '<leader>gu', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[G]it [U]ndo hunk' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Better visual mode indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Remove search highlight
vim.keymap.set('n', '<leader>sn', '<cmd>noh<cr>', { desc = 'Remove search highlight' })

-- Black hole delete
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Black hole delete (no save to regs)' })
