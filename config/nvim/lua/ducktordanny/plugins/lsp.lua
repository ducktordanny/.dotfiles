return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).j
    build = "make install_jsregexp",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {}, tag = "legacy" },

      -- Additional lua configuration, makes nvim stuff amazing!
    },
    config = function()
      require "ducktordanny.plugins.custom.lsp"
    end,
  },
}
