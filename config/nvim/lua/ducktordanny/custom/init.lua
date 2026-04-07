-- Set filetype to htmlangular for HTML files inside Angular projects.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.html",
  group = vim.api.nvim_create_augroup("AngularFiletype", { clear = true }),
  callback = function()
    if vim.fs.root(0, { "angular.json", "nx.json" }) then
      vim.bo.filetype = "htmlangular"
    end
  end,
})
