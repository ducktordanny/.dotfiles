local opt = vim.opt

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "120"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Wrapping
opt.wrap = true
opt.linebreak = true

-- UI
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.showmode = false
opt.completeopt = "menuone,noselect,noinsert"
opt.pumheight = 12
opt.winborder = "rounded"

-- Performance / responsiveness
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 300

-- Undo history
opt.undofile = true
opt.undodir = vim.fn.expand "~/.vim/undodir/"

-- Backspace
opt.backspace = "indent,eol,start"

-- Use ripgrep for :grep when available
if vim.fn.executable "rg" == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Session save targets
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Global status line (used by lualine too)
opt.laststatus = 3
