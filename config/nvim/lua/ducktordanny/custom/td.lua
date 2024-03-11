local M = {}

M.add_local_todo = function(command)
  if command.args ~= nil and command.args ~= "" then
    vim.fn.system("td -a -c " .. command.args)
    print "Done."
  else
    vim.health.report_error "Missing arguments content for TODO."
  end
end

M.show_unresolved_todos = function()
  vim.cmd ":!td -ls-urs"
end

return M
