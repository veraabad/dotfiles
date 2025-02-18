-- WhichKey
return {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      local whichkey = require "which-key"

      local conf = {
        win = {
          border = "single", -- none, single, double, shadow
          -- position = "bottom", -- bottom, top
        },
      }

      local mappings = {
        { "<leader>b", group = "Buffer", nowait = false, remap = false },
        { "<leader>bD", "<Cmd>%bd|e#|bd#<Cr>", desc = "Delete all buffers", nowait = false, remap = false },
        { "<leader>bc", "<Cmd>bd!<Cr>", desc = "Close current buffer", nowait = false, remap = false },

        { "<leader>f", group = "Find", nowait = false, remap = false },
        { "<leader>fa", "<cmd>lua require('utils.finder').find_functions()<cr>", desc = "Find Functions", nowait = false, remap = false },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers", nowait = false, remap = false },
        { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = false, remap = false },
        { "<leader>fd", "<cmd>lua require('utils.finder').find_dotfiles()<cr>", desc = "Dotfiles", nowait = false, remap = false },
        { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = false, remap = false },
        { "<leader>ff", "<cmd>lua require('utils.finder').find_files()<cr>", desc = "Files", nowait = false, remap = false },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep", nowait = false, remap = false },
        { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files", nowait = false, remap = false },
        { "<leader>fr", "<cmd>Telescope file_browser<cr>", desc = "Browser", nowait = false, remap = false },
        { "<leader>fs", "<cmd>lua require('utils.finder').open_ssh_config()<cr>", desc = "SSH Config", nowait = false, remap = false },
        { "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current Buffer", nowait = false, remap = false },

        { "<leader>g", group = "Git", nowait = false, remap = false },
        { "<leader>gs", "<cmd>Neogit<CR>", desc = "Status", nowait = false, remap = false },

        { "<leader>p", group = "Project", nowait = false, remap = false },
        { "<leader>pp", "<cmd>lua require'telescope'.extensions.project.project{}<cr>", desc = "List", nowait = false, remap = false },
        { "<leader>ps", "<cmd>Telescope repo list<cr>", desc = "Search", nowait = false, remap = false },

        { "<leader>q", "<cmd>q!<CR>", desc = "Quit", nowait = false, remap = false },
        { "<leader>w", "<cmd>update!<CR>", desc = "Save", nowait = false, remap = false },

        { "<leader>z", group = "Packer", nowait = false, remap = false },
        { "<leader>zS", "<cmd>PackerStatus<cr>", desc = "Status", nowait = false, remap = false },
        { "<leader>zc", "<cmd>PackerCompile<cr>", desc = "Compile", nowait = false, remap = false },
        { "<leader>zi", "<cmd>PackerInstall<cr>", desc = "Install", nowait = false, remap = false },
        { "<leader>zs", "<cmd>PackerSync<cr>", desc = "Sync", nowait = false, remap = false },
        { "<leader>zu", "<cmd>PackerUpdate<cr>", desc = "Update", nowait = false, remap = false },
        mode = "n",
        prefix = "<leader>",
        silent = true,
        nowait = false,
        noremap = true,
      }

      whichkey.setup(conf)
      whichkey.add(mappings)
    end,
}
