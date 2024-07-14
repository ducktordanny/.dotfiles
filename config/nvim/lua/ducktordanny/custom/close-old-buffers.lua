local M = {}

M.maxBuffers = 20

M.closeLeastRecentlyUsedBuffer = function()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }

  table.sort(buffers, function(a, b)
    return a.lastused < b.lastused
  end)

  vim.cmd("bd " .. buffers[1].bufnr)
end

vim.api.nvim_create_augroup("LimitBuffers", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = "LimitBuffers",
  callback = function()
    local bufferCount = #vim.fn.getbufinfo { buflisted = 1 }

    if bufferCount > M.maxBuffers then
      M.closeLeastRecentlyUsedBuffer()
    end
  end,
})

return M
