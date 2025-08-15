-- LSP

-- Setup LSP handlers
require("plugins.lsp.handlers").setup()

local custom_clangd_setup = function()
  require('lspconfig').clangd.setup({
    cmd = {"/opt/homebrew/opt/llvm/bin/clangd", "--background-index", "-j=8", "--limit-references=0", "--limit-results=0", "--offset-encoding=utf-16", "--log=verbose"},
    -- capabilities = {
    --   offsetEncoding = {"utf-16"},
    -- },
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "h", "hpp" },
    on_attach = function (client, bufnr)
      require('plugins.lsp.keymaps').setup(client, bufnr)
      local whichkey = require "which-key"
      local mappings = {
        { "o", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        -- prefix = "l",
        buffer = bufnr,
        nowait = false,
        noremap = true,
        -- ["o"] = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)" },
      }
      -- whichkey.register(mappings, { buffer = bufnr, prefix = "<leader>" })
      whichkey.add(mappings)
    end,
    root_dir = function(fname)
      return require'lspconfig'.util.root_pattern('compile_commands.json', '.git')(fname) or vim.loop.cwd()
    end,
  })
end

local custom_pyright_setup = function()
  require('lspconfig').pyright.setup({
    on_attach = function(client, bufnr)
      require('plugins.lsp.keymaps').setup(client, bufnr)
    end,
    settings = {
      -- python = {
      --   analysis = {
      --     typeCheckingMode = "basic",
      --   },
      -- },
      pyright = {
        disableOrganizeImports = true,
      },
    },
  })
end

local custom_ruff_setup = function()
  require('lspconfig').ruff.setup({
    enabled = PLUGINS.ruff_opt == "ruff",
    on_attach = function(client, bufnr)
      require('plugins.lsp.keymaps').setup(client, bufnr)
      -- Defer hover functionality to Pyright
      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.documentHighlightProvider = false
      end
    end,
  })
end

return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = { 'gopls', 'html', 'jsonls', 'pyright', 'rust_analyzer', 'vimls', 'clangd', 'ruff', 'lua_ls'},
    handlers = {
      function(server_name)
        require('lspconfig')[server_name].setup({
          on_attach = function(client, bufnr)
            require('plugins.lsp.keymaps').setup(client, bufnr)
          end,
        })
      end,
      clangd = custom_clangd_setup,
      pyright = custom_pyright_setup,
      ruff = custom_ruff_setup,
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
