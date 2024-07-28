return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup {}
    require "ducktordanny.custom.plugins.trouble"
  end,
}
