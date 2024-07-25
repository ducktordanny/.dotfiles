-- tab size
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Make line numbers default
vim.wo.relativenumber = true
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undodir = os.getenv "HOME" .. "/.vim/undodir/"
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Vertical line for character limit in a line
vim.o.colorcolumn = "120"

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

vim.o.incsearch = true
vim.o.hlsearch = false

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Line wrapping
vim.o.wrap = true
vim.o.linebreak = true

-- Backspace
vim.o.backspace = "indent,eol,start"

-- Split windows
vim.o.splitright = true
vim.o.splitbelow = true

-- Scroll thingy
vim.o.scrolloff = 8

-- highlight current line
vim.o.cursorline = true

if vim.fn.executable "rg" == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
end
