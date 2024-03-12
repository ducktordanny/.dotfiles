return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require "harpoon"
    local telescope_config = require "telescope.config"
    local pickers = require "telescope.pickers"
    local themes = require "telescope.themes"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    harpoon:setup()

    -- basic telescope configuration
    local conf = telescope_config.values
    local function toggle_telescope(harpoon_files, selected_index)
      selected_index = selected_index or 1
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      local picker = pickers.new(themes.get_dropdown {}, {
        prompt_title = "Harpoon",
        finder = finders.new_table {
          results = file_paths,
        },
        default_selection_index = selected_index,
        previewer = conf.file_previewer {},
        -- TODO: Custom sorter for highlighting?
        attach_mappings = function(_, map)
          map("i", "<C-d>", function()
            local index = action_state.get_selected_entry().index
            harpoon:list():removeAt(index)
            toggle_telescope(harpoon:list())
          end)
          -- TODO: Refactor logic into separate function and find better keymap
          map("i", "<C-k>", function()
            local index = action_state.get_selected_entry().index
            local new_index = index - 1
            if new_index < 1 then
              new_index = harpoon:list():length()
            end
            local list = harpoon:list().items
            local item_to_move = list[index]
            table.remove(list, index)
            table.insert(list, new_index, item_to_move)
            harpoon:list():clear()
            for _, item in ipairs(list) do
              harpoon:list():append(item)
            end
            toggle_telescope(harpoon:list(), new_index)
          end)
          map("i", "<C-j>", function()
            local index = action_state.get_selected_entry().index
            local new_index = index + 1
            if new_index > harpoon:list():length() then
              new_index = 1
            end
            local list = harpoon:list().items
            local item_to_move = list[index]
            table.remove(list, index)
            table.insert(list, new_index, item_to_move)
            harpoon:list():clear()
            for _, item in ipairs(list) do
              harpoon:list():append(item)
            end
            toggle_telescope(harpoon:list(), new_index)
          end)
          return true
        end,
      })
      picker:find()
    end

    vim.keymap.set("n", "<leader>hh", function()
      harpoon:list():append()
    end)
    vim.keymap.set("n", "<leader>h", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Open harpoon window" })

    vim.keymap.set("n", "<leader>n", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<leader>m", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<leader>,", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<leader>.", function()
      harpoon:list():select(4)
    end)
    vim.keymap.set("n", "<leader>;", function()
      harpoon:list():select(5)
    end)
  end,
}
