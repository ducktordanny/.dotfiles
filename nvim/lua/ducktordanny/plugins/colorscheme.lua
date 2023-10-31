return {
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'deep' }
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'xiyaowong/transparent.nvim',
    opts = {},
  },
}
