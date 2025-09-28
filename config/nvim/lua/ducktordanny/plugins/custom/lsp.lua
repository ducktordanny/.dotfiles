-- NOTE: Node should be installed on system for most of these LSPs
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = {
          globals = { "vim" },
        },
      },
    }
  },
  angularls = {},
  ts_ls = {},
  cssls = {},
  eslint = {
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
    },
  },
  jsonls = {},
  gopls = {},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup {
  ui = {
    border = "single",
  },
}

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers or {}),
  automatic_installation = true,
}

vim.diagnostic.config {
  virtual_text = { spacing = 1, prefix = "●" },
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
}
vim.o.winborder = "rounded"

for server_name, server_options in pairs(servers or {}) do
  local common_options = {
    capabilities = capabilities,
    on_attach = require("ducktordanny.plugins.custom.lsp-attach-remaps").on_attach,
    flags = { debounce_text_changes = 150 },
  }
  local options = vim.tbl_deep_extend("force", common_options, server_options);
  vim.lsp.config(server_name, options)
  vim.lsp.enable(server_name)
end

-- nvim-cmp setup
local cmp = require "cmp"
local luasnip = require "luasnip"
require("luasnip.loaders.from_vscode").lazy_load { paths = { "./snippets", "./.work-snippets" } }
luasnip.config.setup {}

cmp.setup {
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete {},
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
}
