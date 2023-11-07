return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
      local telescope = require "telescope"

      telescope.load_extension "live_grep_args"
      vim.keymap.set("n", "<leader>sg", telescope.extensions.live_grep_args.live_grep_args, { desc = "[S]earch by [G]rep" })

      -- Previewless search
      vim.keymap.set("n", "<leader>sgh", function()
        telescope.extensions.live_grep_args.live_grep_args { previewer = false }
      end, { desc = "[S]earch by [G]rep with [H]idden preview" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
