return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- See `:help lualine.txt`
  opts = {
    options = {
      theme = "onedark",
      component_separators = { left = "", right = "|" },
      section_separators = "",
    },
    sections = {
      lualine_b = {
        "branch",
        "diff",
        {
          "diagnostics",
          symbols = { error = "🚨", warn = "⚠️ ", info = "ℹ️ ", hint = "💬" },
        },
      },
      lualine_c = {
        {
          "filename",
          symbols = {
            modified = "🟢",
            readonly = "🟡",
            unnamed = "⭕️",
            newfile = "⚪️",
          },
        },
      },
    },
  },
}
