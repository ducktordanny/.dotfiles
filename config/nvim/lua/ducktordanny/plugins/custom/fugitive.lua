local M = {}

--- @param is_amend boolean
--- @param no_edit boolean
--- @return function void
M.commit_handler = function(is_amend, no_edit)
  return function()
    if is_amend and no_edit then
      vim.cmd "botright split"
      vim.cmd "term git commit --amend --no-edit"
      vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
      return
    end

    local cwd = vim.loop.cwd()
    local workspace_name = vim.fs.basename(cwd)
    local commit_path = vim.fn.expand(("~/.config/.dotfiles/tmp/%s_COMMIT_EDITMSG"):format(workspace_name))

    if is_amend then
      vim.fn.system(("git log -1 --pretty=%%B > %s"):format(vim.fn.shellescape(commit_path)))
    end

    vim.cmd "split"
    vim.cmd.edit(commit_path)

    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = vim.api.nvim_get_current_buf(),
      once = true,
      callback = function()
        vim.schedule(function()
          vim.cmd "botright split"
          local git_command = ("git commit -F %s"):format(vim.fn.shellescape(commit_path))
          if is_amend then
            git_command = git_command .. " --amend"
          end
          vim.cmd("term " .. git_command)
          vim.cmd "startinsert"
          vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
        end)
      end,
    })
  end
end

vim.keymap.set("n", "<leader>cc", M.commit_handler(false, false), { desc = "Git [C]ommit [c]urrently staged files" })
vim.keymap.set("n", "<leader>cca", M.commit_handler(true, false),
  { desc = "Git [C]ommit [c]urrently staged files with [a]mend" })
vim.keymap.set("n", "<leader>cce", M.commit_handler(true, true),
  { desc = "Git [C]ommit [c]urrently staged files with amend no [e]dit" })

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
