local telescope = require "telescope"
local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local utils = require "telescope.utils"

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
    file_ignore_patterns = { "^.git/" },
    path_display = { shorten = { len = 2, exclude = { 1, 2, -1 } } },
  },
}
vim.cmd [[autocmd! ColorScheme * highlight TelescopeBorder guifg=white guibg=NONE]]

local findFiles = function()
  builtin.find_files { hidden = true }
end
local findDir = function()
  builtin.find_files { find_command = { "fd", "--type", "d" }, prompt_title = "Find Directories" }
end
local findInCwd = function()
  builtin.find_files { cwd = utils.buffer_dir(), hidden = true }
end

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sf", findFiles, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sl", findDir, { desc = "[S]earch Dirs" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "[S]earch [O]ldfiles" })
vim.keymap.set("n", "<leader>ss", findInCwd, { desc = "[S]earch current buffer's directory" })
vim.keymap.set("n", "<leader>sj", builtin.git_branches, { desc = "Search git branches" })
