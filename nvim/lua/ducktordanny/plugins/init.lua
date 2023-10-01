return {
  -- Git like undo tree to manage local history
  'mbbill/undotree',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'rbong/vim-flog',
    dependencies = {
      'tpope/vim-fugitive',
    },
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- LSP thingies
  {
    -- LSP Configuration & Plugins
    'ducktordanny/nvim-lspconfig',
    branch = 'feat/nx-support-for-angularls',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {}, tag = 'legacy' },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  'MunifTanjim/prettier.nvim',
  'RRethy/vim-illuminate',

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  {
    'windwp/nvim-autopairs',
    opts = {
      map_cr = true,
    },
  },
  'alvan/vim-closetag',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      },
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'onedark',
        component_separators = { left = '', right = '|' },
        section_separators = '',
      },
      sections = {
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            symbols = { error = '🚨', warn = '⚠️ ', info = 'ℹ️ ', hint = '💬' },
          },
        },
        lualine_c = {
          {
            'filename',
            symbols = {
              modified = '🟢',
              readonly = '🟡',
              unnamed = '⭕️',
              newfile = '⚪️',
            },
          },
        },
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Telescope, fuzzy finder, etc.
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    -- NOTE: make sure ripgrep is installed
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
    },
    config = function()
      require('neoclip').setup {
        keys = {
          telescope = {
            i = {
              paste_behind = 'C-o',
            },
          },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
      require('telescope').load_extension 'live_grep_args'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- FUN
  -- NOTE: For practicing some vim moves uncomment and install the plugin then do :VimBeGood
  -- 'ThePrimeagen/vim-be-good',
}
