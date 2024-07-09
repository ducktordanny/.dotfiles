return {
  "andythigpen/nvim-coverage",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("coverage").setup {
      commands = true, -- create commands
      highlights = {
        -- customize highlight groups created by the plugin
        covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
        uncovered = { fg = "#F07178" },
      },
      signs = {
        -- use your own highlight groups or text markers
        covered = { hl = "CoverageCovered", text = "C" },
        uncovered = { hl = "CoverageUncovered", text = "U" },
        partial = { hl = "CoveragePartial", text = "P" },
      },
      summary = {
        -- customize the summary pop-up
        min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
      },
      lang = {
        -- customize language specific settings
        javascript = {
          coverage_file = "coverage/lcov.info",
        },
        typescript = {
          coverage_file = "coverage/lcov.info",
        },
      },
    }
    vim.keymap.set("n", "<leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageShow<cr>", { desc = "Load and show coverage" })
  end,
}
