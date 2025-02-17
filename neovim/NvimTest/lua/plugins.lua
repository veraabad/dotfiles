local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    -- Colorscheme
    use {
      "tanvirtin/monokai.nvim",
      config = function()
        require('monokai').setup()
        -- require('monokai').setup { palette = require('monokai').ristretto }
      end,
    }

    -- Startup screen
    use {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    }

    -- Git
    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("config.neogit").setup()
      end,
    }

    use {'airblade/vim-gitgutter'}

    use {
      "f-person/git-blame.nvim",
      config = function()
        require("gitblame").setup()
      end,
    }

    use {
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
    }

    -- Trim whitespace
    use({
      "cappyzawa/trim.nvim",
      config = function()
        require("config.trim").setup()
      end
    })

    -- WhichKey
    use {
       "folke/which-key.nvim",
       event = "VimEnter",
       config = function()
         require("config.whichkey").setup()
       end,
    }

    -- IndentLine
    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    }

    -- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Better Comment
    use {
      "numToStr/Comment.nvim",
      opt = true,
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("Comment").setup {}
      end,
    }

    -- Easy hopping
    use {
      "phaazon/hop.nvim",
      cmd = { "HopWord", "HopChar1" },
      config = function()
        require("hop").setup {}
      end,
    }

    -- Easy motion
    use {
      "ggandor/lightspeed.nvim",
      keys = { "s", "S", "f", "F", "t", "T" },
      config = function()
        require("lightspeed").setup {}
      end,
    }

    -- Markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    }

    -- Status line
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = function()
       require("config.lualine").setup()
      end,
      requires = { "nvim-web-devicons" },
    }

    -- Treesitter
    if PLUGINS.nvim_treesitter.enabled then
      use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
        	local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        	ts_update()
        end,
        opt = true,
        event = "BufRead",
        config = function()
          require("config.treesitter").setup()
        end,
        requires = {
          {"tanvirtin/monokai.nvim"},
          {"nvim-treesitter/nvim-treesitter-textobjects"},
        },
      }

      use {
        "SmiteshP/nvim-gps",
        disable = true,
        requires = "nvim-treesitter/nvim-treesitter",
        module = "nvim-gps",
        config = function()
          require("nvim-gps").setup()
        end,
      }
    end

    -- -- FZF
    -- use { "junegunn/fzf", run = "./install --all" }
    -- use { "junegunn/fzf.vim" }
    --
    -- -- FZF-Lua
    -- use {
    --  "ibhagwan/fzf-lua",
    -- 	requires = { "kyazdani42/nvim-web-devicons" },
    -- }
    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      opt = true,
      config = function()
        require("config.telescope").setup()
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
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
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

    -- Better Netrw
    use {"tpope/vim-vinegar"}

    use {
      "kyazdani42/nvim-tree.lua",
      disable = true,
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
        config = function()
          require("config.nvimtree").setup()
        end,
    }

    -- User interface
    use {
      "stevearc/dressing.nvim",
      event = "BufEnter",
      config = function()
        require("dressing").setup {
          select = {
            backend = { "telescope", "fzf", "builtin" },
          },
        }
      end,
    }

    -- Buffer line
    use {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      config = function()
        require("config.bufferline").setup()
      end,
    }

    -- Completion
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      -- event = "VimEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = vim.tbl_filter(function(plugin)
          -- Check if the plugin is 'zbinrenbaum/copilot-cmp' and whehter PLUGINS.copilot.enabled is true
          if type(plugin) == "string" and plugin == "zbirenbaum/copilot-cmp" then
            return PLUGINS.copilot.enabled
          end
          return true
        end, {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "zbirenbaum/copilot-cmp",
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
            require("config.luasnip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
      }),
    }

    -- Auto pairs
    use {
      "windwp/nvim-autopairs",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }

    -- LSP
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      -- opt = true,
      event = "BufReadPre",
      wants = { "vim-illuminate" },
      requires = {
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
        require("config.lsp").setup()
      end,
    }

    -- Copilot
    if PLUGINS.copilot.enabled then
      use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        -- after = { "copilot.lua", "nvim-cmp" },
        config = function ()
          require("copilot_cmp").setup()
        end
      }

      use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "VimEnter",
        config = function()
          require("copilot").setup({
            panel = { enabled = false },
            sugggestion = { enabled = false },
          })
        end,
      }

      use {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = 'main',
        event = "VimEnter",
        requires = {
          { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
          { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        config = function()
          require("config.copilotChat").setup()
        end,
      }
    end

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
