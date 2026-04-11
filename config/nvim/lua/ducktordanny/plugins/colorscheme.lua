return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    config = function()
      require("rose-pine").setup {
        variant = "moon",
        styles = { transparency = true },
        highlight_groups = {
          typescriptImport = { fg = "rose" },
          typescriptVariable = { fg = "pine" },
          yamlBlockMappingKey = { fg = "rose" },
        },
      }

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ducktordanny_colorscheme_tweaks", { clear = true }),
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff" })
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
    lazy = false,
    priority = 900,
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
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      scope = { show_start = false },
    },
  },
}
