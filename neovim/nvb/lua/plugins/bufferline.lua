-- Buffer line
return {
  "akinsho/nvim-bufferline.lua",
  event = "BufReadPre",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("bufferline").setup {
      options = {
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = "slant" or "padded_slant",
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    }
  end,
}
