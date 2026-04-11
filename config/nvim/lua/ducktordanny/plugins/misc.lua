return {
  -- Jest test runner integration (my own plugin)
  {
    "ducktordanny/jest.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    cmd = { "Jest", "JestFile", "JestLine", "JestWatch" },
  },
}
