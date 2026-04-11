return {
  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    version = "3.1.6",
    opts = {},
  },

  -- Auto-close brackets, quotes, etc. Works with nvim-cmp confirm via map_cr.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { map_cr = true },
  },

  -- HTML tag auto-close
  {
    "alvan/vim-closetag",
    ft = {
      "html",
      "htmlangular",
      "xhtml",
      "xml",
      "phtml",
      "javascriptreact",
      "typescriptreact",
    },
  },

  -- Highlight other instances of the word under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure {
        providers = { "lsp", "treesitter", "regex" },
        delay = 120,
        filetypes_denylist = { "neo-tree", "oil", "TelescopePrompt", "fugitive", "help" },
      }
    end,
  },

  -- Swap arguments/list items
  {
    "machakann/vim-swap",
    keys = {
      { "g<", desc = "Swap left" },
      { "g>", desc = "Swap right" },
      { "gs", desc = "Swap interactive" },
    },
  },
}
