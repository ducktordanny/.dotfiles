return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "rose-pine",
      component_separators = { left = "", right = "|" },
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
}
