return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "disabled",
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true
          },
        },
        buffers = {
          follow_current_file = {
            enabled = true,
          },
        },
        window = {
          mappings = {
            ["<cr>"] = "open",
          },
        },
      })
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#3c3836", bold = true })
    end
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
