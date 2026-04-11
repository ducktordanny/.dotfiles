-- Runs `cmd` in a bottom term split and notifies fugitive on close.
local function git_term(cmd)
  return function()
    vim.cmd "botright split"
    vim.cmd("term " .. cmd)
    vim.cmd "startinsert"
    vim.cmd "autocmd TermClose <buffer> call FugitiveDidChange()"
  end
end

-- Opens a scratch buffer for a commit message (pre-populated with previous
-- message if amending), then runs the commit in a term split on save.
local function commit_handler(amend)
  return function()
    local cwd = vim.uv.cwd()
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
          local git_command = ("git commit -F %s"):format(vim.fn.shellescape(commit_path))
          if amend then
            git_command = git_command .. " --amend"
          end
          git_term(git_command)()
        end)
      end,
    })
  end
end

return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite", "Gedit" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      {
        "<leader>gd",
        function()
          vim.cmd ":Gvdiffsplit!"
          print "target (master) //2 | merge conflict | branch being merged //3"
        end,
        desc = "Git diff preview",
      },
      { "<leader>gc", commit_handler(false), desc = "Git commit" },
      { "<leader>gca", commit_handler(true), desc = "Git commit amend" },
      {
        "<leader>gce",
        function()
          git_term "git commit --amend --no-edit"()
        end,
        desc = "Git commit amend no-edit",
      },
      {
        "<leader>gp",
        git_term "git push --force-with-lease",
        desc = "Git push (--force-with-lease)",
      },
    },
  },

  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = { "tpope/vim-fugitive" },
    keys = {
      { "<leader>gl", "<cmd>Flogsplit<cr>", desc = "Git log" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "‾" },
        topdelete = { text = "‾" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>gu", gs.reset_hunk, "Git undo hunk")
        map("n", "<leader>gj", gs.preview_hunk_inline, "Git hunk inline preview")
        map("v", "ga", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Stage selected hunk")
        map("v", "gr", gs.undo_stage_hunk, "Undo stage for selected hunk")
        map("n", "]h", function() gs.nav_hunk "next" end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk "prev" end, "Prev hunk")
      end,
    },
  },
}
