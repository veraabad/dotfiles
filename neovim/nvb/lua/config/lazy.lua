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
  spec = {
    -- import your plugins
    { import = "plugins" },
    { "tanvirtin/monokai.nvim" },
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

    -- Load only when require
    { "nvim-lua/plenary.nvim", module = "plenary" },

    -- Better icons
    {
      "kyazdani42/nvim-web-devicons",
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
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "monokai" } },
  -- automatically check for plugin updates
  checker = { enabled = false },

})
