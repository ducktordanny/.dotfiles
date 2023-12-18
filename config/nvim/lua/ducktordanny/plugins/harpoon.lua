return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require "harpoon"
    local harpoon_ui = require "harpoon.ui"
    local harpoon_mark = require "harpoon.mark"

    harpoon.setup {
      menu = {
        height = 20,
        width = vim.api.nvim_win_get_width(0) - 40,
      },
    }
    vim.keymap.set("n", "<leader>h", harpoon_ui.toggle_quick_menu)
    vim.keymap.set("n", "<leader>hh", harpoon_mark.add_file)
    vim.keymap.set("n", "<C-n>", harpoon_ui.nav_next)
    vim.keymap.set("n", "<C-p>", harpoon_ui.nav_prev)

    vim.keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end, { desc = "Navigate to harpoon file 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end, { desc = "Navigate to harpoon file 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end, { desc = "Navigate to harpoon file 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end, { desc = "Navigate to harpoon file 4" })
    vim.keymap.set("n", "<leader>5", function() harpoon_ui.nav_file(5) end, { desc = "Navigate to harpoon file 5" })
  end,
}
