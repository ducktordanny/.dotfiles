return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><space>", desc = "Find buffers" },
      { "<leader>sf", desc = "Search files" },
      { "<leader>sg", desc = "Multi grep" },
      { "<leader>ss", desc = "Search current dir" },
      { "<leader>sl", desc = "Search directories" },
      { "<leader>sh", desc = "Search help" },
      { "<leader>sd", desc = "Search diagnostics" },
      { "<leader>sr", desc = "Search resume" },
      { "<leader>so", desc = "Search oldfiles" },
      { "<leader>sj", desc = "Search git branches" },
    },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local builtin = require "telescope.builtin"
      local utils = require "telescope.utils"

      local mappings = {
        ["<C-u>"] = false,
        ["<C-d>"] = "delete_buffer",
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.cycle_history_next,
        ["<C-h>"] = actions.cycle_history_prev,
      }

      telescope.setup {
        defaults = {
          mappings = { i = mappings, n = mappings },
          file_ignore_patterns = { "^.git/", "node_modules/", "%.lock$" },
          path_display = { shorten = { len = 2, exclude = { 1, 2, -1 } } },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            width = 0.9,
            height = 0.85,
          },
          sorting_strategy = "ascending",
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      -- Multi-grep: type `<pattern>  <glob>` (double space separator).
      local RG_FLAGS = {
        "--color=never", "--no-heading", "--with-filename",
        "--line-number", "--column", "--smart-case",
      }
      local function build_multigrep_cmd(prompt)
        if not prompt or prompt == "" then
          return nil
        end
        local pieces = vim.split(prompt, "  ")
        local cmd = { "rg" }
        if pieces[1] and pieces[1] ~= "" then
          vim.list_extend(cmd, { "-e", pieces[1] })
        end
        if pieces[2] and pieces[2] ~= "" then
          vim.list_extend(cmd, { "-g", pieces[2] })
        end
        vim.list_extend(cmd, RG_FLAGS)
        return cmd
      end

      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local make_entry = require "telescope.make_entry"
        local conf = require("telescope.config").values
        local sorters = require "telescope.sorters"

        pickers
          .new(opts, {
            debounce = 100,
            prompt_title = "Multi Grep",
            finder = finders.new_async_job {
              command_generator = build_multigrep_cmd,
              entry_maker = make_entry.gen_from_vimgrep(opts),
              cwd = opts.cwd,
            },
            previewer = conf.grep_previewer(opts),
            sorter = sorters.highlighter_only(opts),
          })
          :find()
      end

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader><space>", builtin.buffers, { desc = "Find buffers" })
      map("n", "<leader>sf", function() builtin.find_files { hidden = true } end, { desc = "Search files" })
      map("n", "<leader>sl", function()
        builtin.find_files { find_command = { "fd", "--type", "d" }, prompt_title = "Find Directories" }
      end, { desc = "Search directories" })
      map("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      map("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      map("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
      map("n", "<leader>so", builtin.oldfiles, { desc = "Search oldfiles" })
      map("n", "<leader>ss", function()
        builtin.find_files { cwd = utils.buffer_dir(), hidden = true }
      end, { desc = "Search current buffer's directory" })
      map("n", "<leader>sj", builtin.git_branches, { desc = "Search git branches" })
      map("n", "<leader>sg", live_multigrep, { desc = "Multi grep (double space = filename filter)" })
    end,
  },
}
