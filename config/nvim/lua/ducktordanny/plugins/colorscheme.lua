return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup {
        variant = "moon",
      }

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = White })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = White })
        end,
      })
      vim.cmd.colorscheme "rose-pine"
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = {
        "NormalFloat",
        "FloatBorder",
        "TelescopeNormal",
        "TelescopeBorder",
      },
    },
  },
}
