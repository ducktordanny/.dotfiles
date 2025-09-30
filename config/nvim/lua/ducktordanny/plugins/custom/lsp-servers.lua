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

return servers
