local augroup = function(name)
  return vim.api.nvim_create_augroup("ducktordanny_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "yank_highlight",
  pattern = "*",
  callback = function()
    vim.hl.on_yank { timeout = 150 }
  end,
})

-- New windows (splits, terminals) should inherit the global relativenumber
-- state set by the <leader>rj toggle in keymaps.lua.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "TermOpen" }, {
  group = augroup "force_relative_numbers",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if vim.wo[win].relativenumber ~= vim.o.relativenumber then
      vim.wo[win].relativenumber = vim.o.relativenumber
    end
  end,
})

-- Angular: switch *.html to htmlangular inside an Angular project root.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup "angular_filetype",
  pattern = "*.html",
  callback = function()
    if vim.fs.root(0, { "angular.json", "nx.json" }) then
      vim.bo.filetype = "htmlangular"
    end
  end,
})

-- Trim trailing whitespace on save (only for normal, modifiable buffers).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "trim_whitespace",
  callback = function(args)
    if vim.b[args.buf].disable_trim_whitespace then
      return
    end
    if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
      return
    end
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(view)
  end,
})

-- Auto-resize splits when window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close various helper buffers with `q`.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "checkhealth",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
