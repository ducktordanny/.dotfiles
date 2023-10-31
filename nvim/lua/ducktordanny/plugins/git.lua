return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set('n', '<leader>ga', '<cmd>Git add --all<cr>', { desc = '[G]it add [a]ll' })
      vim.keymap.set('n', '<leader>gc', '<cmd>Git commit -m ""', { desc = '[G]it [C]ommit' })
      vim.keymap.set('n', '<leader>gs', '<cmd>Git status<cr>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gp', '<cmd>Git push', { desc = '[G]it [P]ush' })
      vim.keymap.set('n', '<leader>gf', '<cmd>Git fetch', { desc = '[G]it [F]etch' })
      vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = '[G]it [B]lame' })
      vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = '[G]it [D]iff preview' })
    end,
  },
  {
    "rbong/vim-flog",
    config = function()
      vim.keymap.set('n', '<leader>gl', '<cmd>Flogsplit<cr>', { desc = '[G]it [L]og' })
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
      vim.keymap.set('n', '<leader>gu', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[G]it [U]ndo hunk' })
      vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns refresh<cr>', { desc = '[G]itsigns [R]efresh' })
    end,
  },
  {
    "kdheepak/lazygit.nvim", -- requires to install lazygit
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
      vim.keymap.set('n', '<leader>l', '<cmd>LazyGit<cr>', { desc = '[L]azyGit' })
    end,
  },
}
