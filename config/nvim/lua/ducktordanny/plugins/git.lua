return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>ga", "<cmd>Git add --all<cr>", { desc = "[G]it add [a]ll" })
      vim.keymap.set("n", "<leader>gc", '<cmd>Git commit -m ""', { desc = "[G]it [C]ommit" })
      vim.keymap.set("n", "<leader>gs", "<cmd>Git status<cr>", { desc = "[G]it [S]tatus" })
      vim.keymap.set("n", "<leader>gp", "<cmd>split<cr><cmd>term git push --force-with-lease<cr>", { desc = "[G]it [P]ush (using --force-with-lease)" })
      vim.keymap.set("n", "<leader>gf", "<cmd>Git fetch<cr>", { desc = "[G]it [F]etch" })
      vim.keymap.set("n", "<leader>grb", "<cmd>Git rebase", { desc = "[G]it [R]e[b]ase" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "[G]it [B]lame" })
      vim.keymap.set("n", "<leader>gd", function()
        vim.cmd ":Gvdiffsplit!"
        print("target (master) //2 | merge conflict | branch being merged //3") -- Reminder :D
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
      require("gitsigns").setup() -- NOTE: This is needed, otherwise it won't load for some reason
      vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[G]it [U]ndo hunk" })
      vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns refresh<cr>", { desc = "[G]itsigns [R]efresh" })
    end,
  },
}
