-- LSP: mason + nvim-lspconfig wired through the 0.11 `vim.lsp.config` / `vim.lsp.enable` API.
-- See nvim/CLAUDE.md for the full flow and the rationale behind `automatic_enable = false`.

local STYLE_FTS = { css = true, scss = true }

local function rename_prompt()
  local cword = vim.fn.expand "<cword>"
  vim.ui.input({ prompt = "Rename to: ", default = cword }, function(new_name)
    if new_name and #new_name > 0 and new_name ~= cword then
      vim.lsp.buf.rename(new_name)
    end
  end)
end

-- Refresh the word-under-cursor highlight on CursorHold; clear it on move.
-- Uses a single shared augroup scoped per buffer so repeat attaches replace
-- the previous autocmds rather than stacking.
local function setup_document_highlight(bufnr)
  local hl_group = vim.api.nvim_create_augroup("ducktordanny_lsp_highlight", { clear = false })
  vim.api.nvim_clear_autocmds { group = hl_group, buffer = bufnr }
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = hl_group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = hl_group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = hl_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds { group = hl_group, buffer = bufnr }
    end,
  })
end

-- ESLint LSP auto-fix on save via its own command.
local function setup_eslint_autofix(bufnr, client)
  vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
    client:request_sync("workspace/executeCommand", {
      command = "eslint.applyAllFixes",
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, nil, bufnr)
  end, {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("ducktordanny_eslint_fix_" .. bufnr, { clear = true }),
    buffer = bufnr,
    command = "LspEslintFixAll",
  })
end

return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "single",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- LSP status notifications.
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local css_nav = require "ducktordanny.css_nav"

      vim.diagnostic.config {
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 2,
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      }

      -- Advertise cmp completion support + dynamic file-watching to every server.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
          didChangeWatchedFiles = { dynamicRegistration = true },
        },
      })

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim", "P" } },
              completion = { callSnippet = "Replace" },
              hint = { enable = true },
            },
          },
        },

        angularls = {},
        cssls = {},
        jsonls = {},
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        typos_lsp = {},
        stylelint_lsp = {
          filetypes = { "css", "scss", "less", "sass" },
        },

        eslint = {
          -- Work around a race: ESLint tries to resolve configs on didOpen
          -- before the workspace root is known. Pin it to the project root.
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, {
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
              "package.json",
            })
            if root then
              on_dir(root)
            end
          end,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "svelte",
            "astro",
            "html",
            "vue",
            "css",
            "scss",
          },
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      }

      -- Apply the default config (capabilities + sane flags) to every server,
      -- then merge in the server-specific overrides.
      local defaults = {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
          allow_incremental_sync = true,
        },
      }

      local server_names = {}
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, vim.tbl_deep_extend("force", defaults, cfg))
        table.insert(server_names, name)
      end

      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = server_names,
        -- Never let mason-lspconfig auto-enable servers. It otherwise enables
        -- every Mason-installed tool that *looks* LSP-capable (e.g. `stylua --lsp`),
        -- which causes phantom attaches. We enable exactly what we configured.
        automatic_enable = false,
      }
      vim.lsp.enable(server_names)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ducktordanny_lsp_attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          local ok_telescope, tb = pcall(require, "telescope.builtin")

          -- `gr`: CSS/SCSS buffers search html/template usages (LSP has no
          -- cross-file CSS class refs). Everything else uses LSP references.
          local gr
          if STYLE_FTS[vim.bo[bufnr].filetype] then
            gr = function() css_nav.find_class_references(bufnr) end
          elseif ok_telescope then
            gr = tb.lsp_references
          else
            gr = vim.lsp.buf.references
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          map("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
          map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
          map("n", "gr", gr, "References")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "KK", vim.lsp.buf.signature_help, "Signature help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<leader>rn", rename_prompt, "Rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

          if ok_telescope then
            map("n", "<leader>ds", tb.lsp_document_symbols, "Document symbols")
            map("n", "<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
          end

          vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
            vim.lsp.buf.format { async = true }
          end, { desc = "Format current buffer with LSP" })

          if client:supports_method "textDocument/inlayHint" then
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
            end, "Toggle inlay hints")
          end

          if client:supports_method "textDocument/documentHighlight" then
            setup_document_highlight(bufnr)
          end

          if client.name == "eslint" then
            setup_eslint_autofix(bufnr, client)
          end

          if client.name == "angularls" then
            -- `gdc`: jump from an HTML class name to the definition in the
            -- co-located Angular component style file.
            map("n", "gdc", function() css_nav.goto_component_class(bufnr) end, "Goto CSS class definition")
          end
        end,
      })
    end,
  },
}
