vim.keymap.set("n", "<leader>gp", function()
  vim.cmd "split"
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
