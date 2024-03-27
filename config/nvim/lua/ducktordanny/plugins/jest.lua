return {
  "ducktordanny/jest.nvim",
  config = function()
    vim.keymap.set("n", "<leader>jf", "<cmd>JestFile<cr>", { desc = "Run this test file with Jest" })
  end,
}
