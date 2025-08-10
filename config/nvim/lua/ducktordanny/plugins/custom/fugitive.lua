local M = {}

--- Runs the `commit --amend --no-edit` command in `:term` which formats the output (e.g. in case of pre-commit,
--- post-commit hooks), and in case of errors it is easier to go through the issue.
M.commit_amend_no_edit = function()
  vim.cmd "botright split"
  vim.cmd "term git commit --amend --no-edit"
  vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
  vim.cmd "startinsert"
end

--- Opens bottom split for commit message with previous message content of the workspace. After edit, it runs the
--- commit command in `:term` which formats the output (e.g. in case of pre-commit, post-commit hooks), and in case
--- of errors it is easier to go through the issue.
--- @param amend? boolean
--- @return function void
M.commit_handler = function(amend)
  return function()
    local cwd = vim.loop.cwd()
    if cwd == nil then
      vim.notify("Could not read cwd.", vim.log.levels.ERROR)
      return
    end
    local cwd_hash = vim.fn.sha256(cwd)
    local commit_path = vim.fn.expand(("~/.config/.dotfiles/tmp/%s_COMMIT_EDITMSG"):format(cwd_hash))

    if amend then
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
          if amend then
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

vim.keymap.set("n", "<leader>gc", M.commit_handler(), { desc = "[G]it [c]ommit" })
vim.keymap.set("n", "<leader>gca", M.commit_handler(true), { desc = "[G]it [c]ommit [a]mend" })
vim.keymap.set("n", "<leader>gce", M.commit_amend_no_edit, { desc = "[G]it [c]ommit amend no [e]dit" })

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
