return {
  -- Nx console features like for NeoVim
  {
    'Equilibris/nx.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('nx').setup {}
    end,
  },

  -- Running Jest unit tests from NeoVim
  { 'mattkubej/jest.nvim', version = '*' },

  -- Remember previously opened buffers
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        pre_save_cmds = { ':NvimTreeClose' },
      }
    end,
  },

  -- Pretty diagnostics, references, telescope results, quickfix and location lists
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup {}
    end,
  },

  -- Visual git plugin
  {
    'tanvirtin/vgit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('vgit').setup {}
    end,
  },

  -- LazyGit
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').load_extension 'lazygit'
    end,
  },

  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('harpoon').setup {
        menu = {
          height = 20,
          width = vim.api.nvim_win_get_width(0) - 20,
        },
      }
    end,
  },
}
