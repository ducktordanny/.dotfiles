local harpoon = require "harpoon"
local telescope_config = require "telescope.config"
local pickers = require "telescope.pickers"
local themes = require "telescope.themes"
local finders = require "telescope.finders"
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
    sorter = conf.generic_sorter {},
    previewer = conf.file_previewer {},
    attach_mappings = function(_, map)
      local function replaceHarpoonItems(current_index, new_index)
        local prompt_content = vim.api.nvim_get_current_line()
        if prompt_content ~= "> " then
          return
        end
        local list = harpoon:list().items
        local item_to_move = list[current_index]
        table.remove(list, current_index)
        table.insert(list, new_index, item_to_move)
        harpoon:list():clear()
        for _, item in ipairs(list) do
          harpoon:list():append(item)
        end
        toggle_telescope(harpoon:list(), new_index)
      end

      map("i", "<C-u>", function()
        if action_state.get_selected_entry() == nil then
          return
        end
        local index = action_state.get_selected_entry().index
        local new_index = index - 1
        if new_index < 1 then
          new_index = harpoon:list():length()
        end
        replaceHarpoonItems(index, new_index)
      end)

      map("i", "<C-d>", function()
        if action_state.get_selected_entry() == nil then
          return
        end
        local index = action_state.get_selected_entry().index
        local new_index = index + 1
        if new_index > harpoon:list():length() then
          new_index = 1
        end
        replaceHarpoonItems(index, new_index)
      end)

      map("i", "<C-r>", function()
        local index = action_state.get_selected_entry().index
        harpoon:list():remove_at(index)
        toggle_telescope(harpoon:list())
      end)

      return true
    end,
  })
  picker:find()
end

vim.keymap.set("n", "<leader>hh", function()
  harpoon:list():add()
end, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<leader>h", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon ui with telescope" })

vim.keymap.set("n", "<leader>n", function()
  harpoon:list():select(1)
end, { desc = "Navigate to harpoon file 1" })
vim.keymap.set("n", "<leader>m", function()
  harpoon:list():select(2)
end, { desc = "Navigate to harpoon file 2" })
vim.keymap.set("n", "<leader>,", function()
  harpoon:list():select(3)
end, { desc = "Navigate to harpoon file 3" })
vim.keymap.set("n", "<leader>.", function()
  harpoon:list():select(4)
end, { desc = "Navigate to harpoon file 4" })
vim.keymap.set("n", "<leader>;", function()
  harpoon:list():select(5)
end, { desc = "Navigate to harpoon file 5" })
