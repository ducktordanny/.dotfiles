return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    }
    vim.keymap.set("n", "<leader>ar", "<cmd>SessionRestore", { desc = "[A]uto-session [R]estore" })
  end,
}
