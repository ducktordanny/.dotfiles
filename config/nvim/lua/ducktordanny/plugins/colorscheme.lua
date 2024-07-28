return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        variant = "moon",
        highlight_groups = {
          typescriptImport = { fg = "rose" },
          typescriptVariable = { fg = "pine" },
          yamlBlockMappingKey = { fg = "rose" },
        },
      }

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = White })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = White })
          vim.api.nvim_set_hl(0, "IlluminatedWordText", { bold = true })
          vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bold = true })
          vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bold = true })
        end,
      })
      vim.cmd.colorscheme "rose-pine-moon"
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
        "TroubleText",
        "TroubleCount",
        "TroubleNormal",
        "TroubleIndent",
        "TroubleLocation",
        "TroublePreview",
        "TroubleFile",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
}
