return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "rose-pine",
        component_separators = { left = "", right = "|" },
        section_separators = "",
        globalstatus = true,
        fmt = string.lower,
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            symbols = { error = "🚨 ", warn = "⚠️  ", info = "ℹ️  ", hint = "💬 " },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = "🟢",
              readonly = "🟡",
              unnamed = "⭕️",
              newfile = "⚪️",
            },
          },
        },
        lualine_x = { "filetype" },
      },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>ti", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>tI", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP definitions/references (Trouble)",
      },
      { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- Earlier versions had more compact popups; user prefers this pin.
    commit = "ccf0276",
    dependencies = { "echasnovski/mini.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}
