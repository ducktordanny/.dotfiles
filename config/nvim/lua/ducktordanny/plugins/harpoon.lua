return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require "harpoon"

    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new(require("telescope.themes").get_dropdown {}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
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
