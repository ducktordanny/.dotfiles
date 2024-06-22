return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "[D]ap toggle [b]reakpoint" },
      { "<leader>dr", "<cmd>DapContinue<cr>", desc = "[D]ap continue [r]un" },
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
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}