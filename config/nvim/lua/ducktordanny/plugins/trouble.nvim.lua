return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup {}
    require "ducktordanny.plugins.custom.trouble"
  end,
}
