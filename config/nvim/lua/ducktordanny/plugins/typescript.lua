return {
  {
    "pmizio/typescript-tools.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      settings = {
        separate_diagnostic_server = false,
        publish_diagnostic_on = "insert_leave",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
        tsserver_format_options = {
          insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
          semicolons = "insert",
        },
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        tsserver_max_memory = 12288,
      },
    },
    keys = {
      { "<leader>ri", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "TSTools: Remove unused imports" },
      { "<leader>rA", "<cmd>TSToolsAddMissingImports<cr>", desc = "TSTools: Add missing imports" },
      { "<leader>rO", "<cmd>TSToolsOrganizeImports<cr>", desc = "TSTools: Organize imports" },
    },
  },

  -- Translates cryptic TS diagnostics into human-readable explanations.
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    opts = {
      auto_attach = true,
    },
  },
}
