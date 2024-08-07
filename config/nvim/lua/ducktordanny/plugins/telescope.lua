return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "ducktordanny.custom.plugins.telescope"
    end,
  },
  {
    -- NOTE: make sure ripgrep is installed
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    build = "make",
    cond = function()
      return vim.fn.executable "make" == 1
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
  }
}
