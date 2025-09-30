local servers = require "ducktordanny.plugins.custom.lsp-servers"

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

require "ducktordanny.plugins.custom.cmp"
