-- Auto pairs
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, 
  config = function()
    local npairs = require "nvim-autopairs"
    npairs.setup {
      check_ts = true,
    }
    npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
  end,
}
