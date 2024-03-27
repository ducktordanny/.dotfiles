return {
  "karb94/neoscroll.nvim",
  config = function()
    -- A plugin so my coworkers can see more easily what I'm doing :)
    vim.api.nvim_create_user_command("NeoscrollEnable", function()
      require("neoscroll").setup {}
    end, {})
  end,
}
