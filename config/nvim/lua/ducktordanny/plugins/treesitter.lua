return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "typescript",
          "tsx",
          "javascript",
          "lua",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "go",
          "bash",
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
