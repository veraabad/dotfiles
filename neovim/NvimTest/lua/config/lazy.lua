-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('lazy').setup({
  -- Colorscheme
  {
    "tanvirtin/monokai.nvim",
    config = function()
      require('monokai').setup()
      -- require('monokai').setup { palette = require('monokai').ristretto }
    end,
  },

  -- Startup screen
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.alpha").setup()
    end,
  },

  -- Git
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("plugins.neogit").setup()
    end,
  },

  {'airblade/vim-gitgutter'},

  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup()
    end,
  },

  {
      'cameron-wags/rainbow_csv.nvim',
      config = function()
          require 'rainbow_csv'.setup()
      end,
      -- optional lazy-loading below
      module = {
          'rainbow_csv',
          'rainbow_csv.fns'
      },
      ft = {
          'csv',
          'tsv',
          'csv_semicolon',
          'csv_whitespace',
          'csv_pipe',
          'rfc_csv',
          'rfc_semicolon'
      }
  },

  -- Trim whitespace
  {
    "cappyzawa/trim.nvim",
    config = function()
      require("plugins.trim").setup()
    end
  },

  -- WhichKey
  {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("plugins.whichkey").setup()
      end,
  },

  -- IndentLine
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("plugins.indentblankline").setup()
    end,
  },

  -- Load only when require
  { "nvim-lua/plenary.nvim", module = "plenary" },

  -- Better icons
  {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  },

  -- Better Comment
  {
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("Comment").setup {}
    end,
  },

  -- Easy hopping
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopChar1" },
    config = function()
      require("hop").setup {}
    end,
  },

  -- Easy motion
  {
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "f", "F", "t", "T" },
    config = function()
      require("lightspeed").setup {}
    end,
  },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("plugins.lualine").setup()
    end,
    dependencies = { "nvim-web-devicons" },
  },

  -- Treesitter
  -- TODO: get conditionals to work again
  -- if PLUGINS.nvim_treesitter.enabled then
  -- end
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    opt = true,
    event = "BufRead",
    config = function()
      require("plugins.treesitter").setup()
    end,
    dependencies = {
      {"tanvirtin/monokai.nvim"},
      {"nvim-treesitter/nvim-treesitter-textobjects"},
    },
  },

  {
    "SmiteshP/nvim-gps",
    disable = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    module = "nvim-gps",
    config = function()
      require("nvim-gps").setup()
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require("plugins.telescope").setup()
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
  },

  -- Better Netrw
  {"tpope/vim-vinegar"},

  {
    "kyazdani42/nvim-tree.lua",
    disable = true,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("plugins.nvimtree").setup()
      end,
  },

  -- User interface
  {
    "stevearc/dressing.nvim",
    event = "BufEnter",
    config = function()
      require("dressing").setup {
        select = {
          backend = { "telescope", "fzf", "builtin" },
        },
      }
    end,
  },

  -- Buffer line
  {
    "akinsho/nvim-bufferline.lua",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    config = function()
      require("plugins.bufferline").setup()
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    -- event = "VimEnter",
    opt = true,
    config = function()
      require("plugins.cmp").setup()
    end,
    wants = { "LuaSnip" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      -- "zbirenbaum/copilot-cmp",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-calc",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-emoji",
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require("plugins.luasnip").setup()
        end,
      },
      "rafamadriz/friendly-snippets",
    },
    -- dependencies = vim.tbl_filter(function(plugin)
        -- TODO: fix this
        -- Check if the plugin is 'zbinrenbaum/copilot-cmp' and whehter PLUGINS.copilot.enabled is true
        -- if type(plugin) == "string" and plugin == "zbirenbaum/copilot-cmp" then
        --   return PLUGINS.copilot.enabled
        -- end
        -- return true
      -- end, 
    -- }),
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    wants = "nvim-treesitter",
    module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
    config = function()
      require("plugins.autopairs").setup()
    end,
  },

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    -- opt = true,
    event = "BufReadPre",
    wants = { "vim-illuminate" },
    dependencies = {
      --- Uncomment the two plugins below if you want to manage the language servers from neovim
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- LSP Support
      {'neovim/nvim-lspconfig'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
      -- Higlight
      {"RRethy/vim-illuminate"},
    },
    config = function()
      require("plugins.lsp").setup()
    end,
  },

  -- Copilot
  -- TODO: enable again
  -- if PLUGINS.copilot.enabled then
  --   {
  --     "zbirenbaum/copilot-cmp",
  --     config = function ()
  --       require("copilot_cmp").setup()
  --     end
  --   },
  --
  --   {
  --     "zbirenbaum/copilot.lua",
  --     cmd = "Copilot",
  --     event = "VimEnter",
  --     dependencies = {
  --       "zbirenbaum/copilot-cmp",
  --     }
  --     config = function()
  --       require("copilot").setup({
  --         panel = { enabled = false },
  --         sugggestion = { enabled = false },
  --       })
  --     end,
  --   },
  --
  --   {
  --     'CopilotC-Nvim/CopilotChat.nvim',
  --     branch = 'main',
  --     event = "VimEnter",
  --     dependencies = {
  --       { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --       { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --     },
  --     config = function()
  --       require("plugins.copilotChat").setup()
  --     end,
  --   },
  -- end
})
