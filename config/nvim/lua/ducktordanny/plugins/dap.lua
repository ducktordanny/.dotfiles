return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dj", "<cmd>DapContinue<cr>", desc = "Dap continue" },
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "[D]ap toggle [b]reakpoint" },
      { "<leader>ds", "<cmd>DapStepOver<cr>", desc = "[D]ap [s]tep over" },
      { "<leader>do", "<cmd>DapStepOut<cr>", desc = "[D]ap step [o]ut" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "[D]ap step [i]nto" },
    },
    config = function()
      local dap = require "dap"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = 8123,
        executable = {
          command = "js-debug-adapter",
        },
      }
      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        -- Should have repo cloned, insatll deps, build
        args = { os.getenv "HOME" .. "/.config/.dotfiles/.repos/vscode-chrome-debug/out/src/chromeDebug.js" },
      }

      for _, language in ipairs { "typescript", "javascript" } do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch File",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = "node",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Auto Attach",
            cwd = vim.fn.getcwd(),
          },
          {
            type = "chrome",
            request = "attach",
            name = "Chrome",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup {
        icons = {
          expanded = "",
          collapsed = "",
          current_frame = "",
        },
        controls = {
          icons = {
            pause = "",
            play = "",
            step_into = "󰆹",
            step_over = "󰆷",
            step_out = "󰆸",
            step_back = "",
            run_last = "󰑆",
            terminate = "",
            disconnect = "",
          },
        },
      }
      vim.keymap.set("n", "<leader>du", dapui.open, { desc = "[D]ap [U]I" })
      vim.keymap.set("n", "<leader>duc", dapui.close, { desc = "[D]ap [U]I [C]lose" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
