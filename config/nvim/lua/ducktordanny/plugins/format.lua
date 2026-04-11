return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>ff",
        function()
          require("conform").format { lsp_fallback = true, async = true }
        end,
        mode = { "n", "v" },
        desc = "Format buffer / selection",
      },
    },
    opts = function()
      local prettier = { "prettierd", "prettier", stop_after_first = true }
      return {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = prettier,
          typescript = prettier,
          javascriptreact = prettier,
          typescriptreact = prettier,
          svelte = prettier,
          css = prettier,
          scss = prettier,
          html = prettier,
          -- htmlangular: prettierd doesn't recognize the filetype, use prettier directly.
          htmlangular = { "prettier" },
          json = prettier,
          yaml = prettier,
          markdown = prettier,
          go = { "gofmt" },
        },
        -- Format after write, asynchronously, so save never blocks on a formatter.
        format_after_save = {
          lsp_fallback = true,
        },
      }
    end,
  },
}
