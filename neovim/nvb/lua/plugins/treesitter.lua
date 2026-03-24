-- Treesitter
-- TODO: get conditionals to work again
-- if PLUGINS.nvim_treesitter.enabled then
-- end
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufRead",
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath("data") .. "/site",
      -- A list of parser names, or "all"
      ensure_installed = {
        "arduino", "asm", "bash", "bitbake", "capnp", "c", "cmake", "cpp", "comment", "csv",
        "dart", "diff", "disassembly", "dockerfile", "doxygen", "git_config", "git_rebase",
        "gitattributes", "gitcommit", "gpg", "html", "http", "ini", "ipkg", "javascript",
        "jq", "json", "lua", "make", "markdown", "markdown_inline", "nginx", "objdump", "passwd",
        "python", "query", "regex", "rust", "sql", "ssh_config", "swift", "tmux", "udev", "vim",
        "vimdoc", "xml", "yaml"
      },

      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,

      highlight = {
        -- `false` will disable the whole extension
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },

      indent = { enable = true },
    }
  end,
  dependencies = {
    {"nvim-treesitter/nvim-treesitter-textobjects"},
  },
}
