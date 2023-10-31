return {
  "RRethy/vim-illuminate",
  config = function()
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bold = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bold = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bold = true })
  end,
}
