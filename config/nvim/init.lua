-- Leaders must be set before lazy.nvim loads so plugin keymaps pick them up.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Global debug helper: P({ ... }) pretty-prints any value.
_G.P = function(v)
  print(vim.inspect(v))
  return v
end

require "ducktordanny.options"
require "ducktordanny.keymaps"
require "ducktordanny.autocmds"
require "ducktordanny.lazy"
