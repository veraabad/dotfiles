return {
  "L3MON4D3/LuaSnip",
  dependencies = { "friendly-snippets" },
  config = function()
    local luasnip = require "luasnip"

    luasnip.config.set_config {
      history = false,
      updateevents = "TextChanged,TextChangedI",
    }

    require("luasnip/loaders/from_vscode").load()
  end,
}
