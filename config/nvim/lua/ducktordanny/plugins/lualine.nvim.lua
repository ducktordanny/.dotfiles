local function get_current_worktree()
  local worktree = require "ducktordanny.custom.worktree"
  local worktree_details = worktree._get_worktree_paths()
  return worktree_details.current_tree
end
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
        "branch",
        get_current_worktree,
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
