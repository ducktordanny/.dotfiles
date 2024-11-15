-- ARCHIVED from: config/nvim/lua/ducktordanny/core/remaps.lua
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open [e]xplorer with Explore" })
vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  desc = "Better mappings for netrw",
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { remap = true, buffer = true })
    end

    bind("<C-l>", "<cmd>TmuxNavigateRight<cr>")
    bind("<c-h>", "<cmd>TmuxNavigateLeft<cr>")
  end,
})

-- ARCHIVED from: config/nvim/lua/ducktordanny/core/settings.lua
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
