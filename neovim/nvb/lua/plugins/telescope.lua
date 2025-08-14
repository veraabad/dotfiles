-- Telescope

-- Custom actions
local transform_mod = require("telescope.actions.mt").transform_mod
local nvb_actions = transform_mod {
  file_path = function(prompt_bufnr)
    -- Get selected entry and the file full path
    local content = require("telescope.actions.state").get_selected_entry()
    local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

    -- Yank the path to unnamed register
    vim.fn.setreg('"', full_path)

    -- Close the popup
    require("utils").info "File path is yanked "
    require("telescope.actions").close(prompt_bufnr)
  end,
}

return {
  "nvim-telescope/telescope.nvim",
  opt = true,
  config = function()
    local actions = require "telescope.actions"
    local telescope = require "telescope"

    local telescope_setup = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "ivy",
          mappings = {
            n = {
              ["y"] = nvb_actions.file_path,
            },
            i = {
              ["<C-y>"] = nvb_actions.file_path,
            },
          },
        },
        git_files = {
          theme = "dropdown",
          mappings = {
            n = {
              ["y"] = nvb_actions.file_path,
            },
            i = {
              ["<C-y>"] = nvb_actions.file_path,
            },
          },
        },
      },
    }
    telescope.setup(telescope_setup)

    telescope.load_extension "fzf"
    telescope.load_extension "project" -- telescope-project.nvim
    telescope.load_extension "repo"
    telescope.load_extension "file_browser"
    telescope.load_extension "projects" -- project.nvim
  end,
  cmd = { "Telescope" },
  module = "telescope",
  keys = { "<leader>f", "<leader>p" },
  wants = {
    "plenary.nvim",
    "popup.nvim",
    "telescope-fzf-native.nvim",
    "telescope-project.nvim",
    "telescope-repo.nvim",
    "telescope-file-browser.nvim",
    "project.nvim",
  },
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-project.nvim",
    "cljoly/telescope-repo.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup {}
      end,
    },
  },
}
