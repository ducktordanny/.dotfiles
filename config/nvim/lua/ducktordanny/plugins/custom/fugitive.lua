vim.keymap.set("n", "<leader>cc", function()
  local cwd = vim.loop.cwd()
  local workspace_name = vim.fs.basename(cwd)
  local commit_path = vim.fn.expand(("~/.config/.dotfiles/tmp/%s_COMMIT_EDITMSG"):format(workspace_name))
  vim.cmd "split"
  vim.cmd.edit(commit_path)

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = vim.api.nvim_get_current_buf(),
    once = true,
    callback = function()
      vim.cmd "botright split"
      vim.cmd(("term git commit -F %s"):format(vim.fn.shellescape(commit_path)))
      -- TODO: Focus the newly created split
      -- But it isn't that simple, because autocmd messes up things... :(
    end,
  })
end, { desc = "Git [C]ommit [c]urrently staged files" })

vim.keymap.set("n", "<leader>gp", function()
  vim.cmd "botright split"
  vim.cmd "term git push --force-with-lease"
  vim.cmd "startinsert"
  vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
end, { desc = "[G]it [P]ush (using --force-with-lease)" })

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "[G]it [B]lame" })

vim.keymap.set("n", "<leader>gd", function()
  vim.cmd ":Gvdiffsplit!"
  print "target (master) //2 | merge conflict | branch being merged //3" -- Reminder :D
end, { desc = "[G]it [D]iff preview" })
vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "[G]it" })
