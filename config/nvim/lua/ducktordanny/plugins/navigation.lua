return {
  -- Oil: browse directory as buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Oil file browser" },
    },
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<leader>sp"] = { "actions.select", opts = { vertical = true } },
        ["<leader>rl"] = "actions.refresh",
      },
      win_options = {
        winbar = "%{v:lua.require('oil').get_current_dir()}",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- Tree-style file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filesystem = {
        hijack_netrw_behavior = "disabled",
        follow_current_file = { enabled = true, leave_dirs_open = true },
      },
      buffers = {
        follow_current_file = { enabled = true },
      },
      window = {
        mappings = { ["<cr>"] = "open" },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#3c3836", bold = true })
    end,
  },

  -- Propagate LSP workspace file renames/moves.
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    opts = {},
  },

  -- Harpoon v2: quick file jumping to 5 pinned slots.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = function()
      local keys = {
        {
          "<leader>hh",
          function() require("harpoon"):list():add() end,
          desc = "Harpoon: add file",
        },
        {
          "<leader>h",
          function()
            local harpoon = require "harpoon"
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon: menu",
        },
      }
      for i, lhs in ipairs { "<leader>n", "<leader>m", "<leader>,", "<leader>.", "<leader>;" } do
        table.insert(keys, {
          lhs,
          function() require("harpoon"):list():select(i) end,
          desc = "Harpoon slot " .. i,
        })
      end
      return keys
    end,
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Tmux-aware window navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Nav left (Tmux-aware)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Nav down (Tmux-aware)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Nav up (Tmux-aware)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Nav right (Tmux-aware)" },
    },
  },

  -- Undotree visualizer
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeFocus" },
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree toggle" },
    },
  },
}
