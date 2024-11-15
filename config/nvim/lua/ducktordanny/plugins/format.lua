return {
  "MunifTanjim/prettier.nvim",
  {
    "stevearc/conform.nvim",
    dependencies = { "MunifTanjim/prettier.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function()
      require "ducktordanny.plugins.custom.conform"
    end,
  },
}
