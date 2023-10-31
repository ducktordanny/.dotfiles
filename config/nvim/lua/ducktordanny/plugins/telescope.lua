return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local builtin = require "telescope.builtin"

      local telescope_mappings = {
        ["<C-u>"] = false,
        ["<C-d>"] = "delete_buffer",
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.cycle_history_next,
        ["<C-h>"] = actions.cycle_history_prev,
      }

      telescope.setup {
        defaults = {
          mappings = {
            i = telescope_mappings,
            n = telescope_mappings,
          },
          file_ignore_patterns = {},
        },
      }

      -- See `:help telescope.builtin`
      vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find,
        { desc = "[/] Fuzzily search in current buffer" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "[S]earch [O]ldfiles" })
    end,
  },
  {
    -- NOTE: make sure ripgrep is installed
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    build = "make",
    cond = function()
      return vim.fn.executable "make" == 1
    end,
  },
}
