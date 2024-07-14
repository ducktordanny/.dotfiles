return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gp", function()
        vim.cmd "split"
        vim.cmd "term git push --force-with-lease"
        vim.cmd "startinsert"
        vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
      end, { desc = "[G]it [P]ush (using --force-with-lease)" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "[G]it [B]lame" })
      vim.keymap.set("n", "<leader>gd", function()
        vim.cmd ":Gvdiffsplit!"
        print "target (master) //2 | merge conflict | branch being merged //3" -- Reminder :D
      end, { desc = "[G]it [D]iff preview" })
      vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "[G]it" })
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
      vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[G]it [U]ndo hunk" })
    end,
  },
}
