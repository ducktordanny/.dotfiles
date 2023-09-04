local prettier = require 'prettier'
local ft = require 'guard.filetype'
local guard = require 'guard'

local filetypes = {
  'css',
  'graphql',
  'html',
  'javascript',
  'javascriptreact',
  'json',
  'less',
  'markdown',
  'scss',
  'typescript',
  'typescriptreact',
  'yaml',
}

prettier.setup {
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes,
}

ft('typescript,javascript,typescriptreact'):fmt 'prettier'
ft('lua'):fmt 'stylua'

guard.setup {
  -- the only options for the setup function
  fmt_on_save = true,
  -- Use lsp if no formatter was defined for this filetype
  lsp_as_default_formatter = false,
}
