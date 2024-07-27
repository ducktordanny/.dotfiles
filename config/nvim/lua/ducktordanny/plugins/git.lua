return {
  {
    "tpope/vim-fugitive",
    config = function()
      require "ducktordanny.custom.plugins.fugitive"
    end,
  },
  {
    "rbong/vim-flog",
    config = function()
      vim.keymap.set("n", "<leader>gl", "<cmd>Flogsplit<cr>", { desc = "[G]it [L]og" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
    },
    config = function()
      require("gitsigns").setup()
      require "ducktordanny.custom.plugins.gitsigns"
    end,
  },
}
