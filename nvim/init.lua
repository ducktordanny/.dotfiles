--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'ducktordanny.plugins' },
}, {})

require 'ducktordanny.settings'
require 'ducktordanny.globals'
require 'ducktordanny.remaps.basic'
require 'ducktordanny.remaps.lsp'
require 'ducktordanny.remaps.telescope'
require 'ducktordanny.remaps.treesitter'
require 'ducktordanny.remaps.formatting'
require 'ducktordanny.custom.worktree'
