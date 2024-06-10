local M = {}

-- Setup LSP handlers
require("config.lsp.handlers").setup()

function custom_clangd_setup()
  require('lspconfig').clangd.setup({
    cmd = {"/opt/homebrew/opt/llvm/bin/clangd", "--background-index", "-j=8", "--limit-references=0", "--limit-results=0", "--log=verbose"},
    capabilities = {
      offsetEncoding = {"utf-16"},
    },
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "h", "hpp" },
    on_attach = function (client, bufnr)
      local whichkey = require "which-key"
      local mappings = {
        ["o"] = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)" },
      }
      whichkey.register(mappings, { buffer = bufnr, prefix = "<leader>" })
    end,
    root_dir = function(fname)
      return require'lspconfig'.util.root_pattern('compile_commands.json', '.git')(fname) or vim.loop.cwd()
    end,
  })
end

function custom_pyright_setup()
  require('lspconfig').pyright.setup({
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
        },
      },
      pyright = {
        disableOrganizeImports = false,
      },
    },
  })
end

function custom_ruff_setup()
  require('lspconfig').ruff.setup({
    on_attach = function(client, bufnr)
      -- Defer hover functionality to Pyright
      if client.resolved_capabilities ~= nil then
        client.resolved_capabilities.hover = false
      end
    end,
  })
end

function M.setup()
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(client, bufnr)
    -- Configure keymapping
    require('config.lsp.keymaps').setup(client, bufnr)

    -- Configure highlighting
    require("config.lsp.highlighting").setup(client)
  end)

  -- to learn how to use mason.nvim with lsp-zero
  -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { 'gopls', 'html', 'jsonls', 'pyright', 'rust_analyzer', 'tsserver', 'vimls', 'clangd', 'ruff'},
    handlers = {
      lsp_zero.default_setup,
      clangd = custom_clangd_setup,
      pyright = custom_pyright_setup,
      ruff = custom_ruff_setup,
    },
  })
  local lua_opts = lsp_zero.nvim_lua_ls()
  require('lspconfig').lua_ls.setup(lua_opts)
end

return M
