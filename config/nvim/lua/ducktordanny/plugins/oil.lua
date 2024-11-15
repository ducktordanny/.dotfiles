return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup {
      keymaps = {
        ["<C-h>"] = false,
        ["<leader>sp"] = { "actions.select", opts = { vertical = true } },
        ["<C-l>"] = false,
        ["<leader>rl"] = "actions.refresh",
      },
      win_options = {
        winbar = "%{v:lua.require('oil').get_current_dir()}",
      },
      view_options = {
        show_hidden = true,
      },
    }
    vim.keymap.set("n", "-", "<cmd>Oil<cr>")
  end,
}
