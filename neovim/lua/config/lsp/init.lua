local M = {}

-- Setup LSP handlers
require("config.lsp.handlers").setup()

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
      -- Defer hover functionality to Pyright
      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.documentHighlightProvider = false
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
    if client.name ~= "ruff" then  -- Exclude Ruff from highlighting
      require("config.lsp.highlighting").setup(client)
    end
  end)

  -- to learn how to use mason.nvim with lsp-zero
  -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { 'gopls', 'html', 'jsonls', 'pyright', 'rust_analyzer', 'vimls', 'clangd', 'ruff'},
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
