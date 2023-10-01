local prettier = require 'prettier'
local conform = require 'conform'

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

conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    svelte = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    go = { 'gofmt' },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    conform.format { bufnr = args.buf }
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
  conform.format {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  }
end, { desc = 'Format file in normal or range in visual mode' })
