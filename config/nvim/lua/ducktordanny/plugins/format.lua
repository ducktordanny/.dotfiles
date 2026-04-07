return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function()
      require "ducktordanny.plugins.custom.conform"
    end,
  },
}
