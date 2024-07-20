local worktree = require "ducktordanny.custom.worktree"

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "rose-pine",
      component_separators = { left = "", right = "|" },
      section_separators = "",
    },
    sections = {
      lualine_b = {
        worktree.get_current_worktree,
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
