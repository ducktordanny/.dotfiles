vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ducktordanny-lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", function()
      local cword = vim.fn.expand "<cword>"
      local new_name = vim.fn.input("Rename to: ", cword)
      if new_name and #new_name > 0 and new_name ~= cword then
        vim.lsp.buf.rename(new_name) -- name is provided -> no more extra prompts
      end
    end, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("KK", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    -- Go to CSS class definition in Angular component styles
    if client and client.name == "angularls" then
      nmap("gdc", function()
        local class = vim.fn.expand "<cword>"
        local html_file = vim.api.nvim_buf_get_name(bufnr)
        -- Find co-located style file (.scss, .css, .sass, .less)
        local base = html_file:gsub("%.component%.html$", ".component.")
        local style_file
        for _, ext in ipairs({ "scss", "css", "sass", "less" }) do
          local candidate = base .. ext
          if vim.uv.fs_stat(candidate) then
            style_file = candidate
            break
          end
        end
        if not style_file then
          vim.notify("No component style file found", vim.log.levels.WARN)
          return
        end
        -- Search for .className pattern in the style file
        local lines = vim.fn.readfile(style_file)
        for i, line in ipairs(lines) do
          if line:match("%." .. vim.pesc(class) .. "[%s,:{%%]") or line:match("%." .. vim.pesc(class) .. "$") then
            vim.cmd("edit " .. vim.fn.fnameescape(style_file))
            vim.api.nvim_win_set_cursor(0, { i, line:find("%." .. vim.pesc(class)) - 1 })
            return
          end
        end
        vim.notify("Class ." .. class .. " not found in " .. vim.fn.fnamemodify(style_file, ":t"), vim.log.levels.WARN)
      end, "Go to [C]SS class definition")
    end

    if client and client.name == "eslint" then
      vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
        client.request_sync("workspace/executeCommand", {
          command = "eslint.applyAllFixes",
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
            },
          },
        }, nil, bufnr)
      end, {})
    end
  end,
})
