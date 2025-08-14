-- Startup screen
return {
  "goolord/alpha-nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
      return
    end

    local dashboard = require "alpha.themes.dashboard"
    local function header()
      return {
        [[               ***                                       ***               ]],
        [[              ****                                       ****              ]],
        [[              *****                                     *****              ]],
        [[             *******                                   *******             ]],
        [[             *******                                   *******             ]],
        [[            *********                                 *********            ]],
        [[           **********                                 **********           ]],
        [[           ***********                               ***********           ]],
        [[          *************                             *************          ]],
        [[          *************                             *************          ]],
        [[         ***************                           ***************         ]],
        [[         ***************                           ***************         ]],
        [[        *****************                         *****************        ]],
        [[       ++++++++++++++++++*************************++++++++++++++++++       ]],
        [[       --=++++++++++++++++***********************+++++++++++++++++--       ]],
        [[      ----=+++++++++++++++***********************+++++++++++++++=----      ]],
        [[      ------+++++++++++++++*********************+++++++++++++++------      ]],
        [[     --------=++++++++++++++********************+++++++++++++=--------     ]],
        [[    -----------+++++++++++++*******************+++++++++++++=----------    ]],
        [[    ------------=++++++++++++*****************++++++++++++=------------    ]],
        [[   --------------=+++++++++++*****************+++++++++++=--------------   ]],
        [[     --------------+++++++++++***************+++++++++++---------------    ]],
        [[       -------------=+++++++++***************+++++++++=-------------       ]],
        [[         -------------+++++++++*************+++++++++-------------         ]],
        [[            -----------=++++++++***********++++++++=-----------            ]],
        [[              ----------=+++++++***********+++++++=----------              ]],
        [[                 ---------+++++++*********+++++++---------                 ]],
        [[                   --------=+++++*********+++++=--------                   ]],
        [[                      -------+++++*******+++++-------                      ]],
        [[                        ------=++++*****++++=------                        ]],
        [[                           ----=+++*****+++=----                           ]],
        [[                             ----+++***+++----                             ]],
        [[                                --=+***+=---                               ]],
        [[                                  --+*+--                                  ]],
        [[                                    -+-                                    ]],
      }
    end

    dashboard.section.header.val = header()

    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
      dashboard.button("q", "󰅙  Quit Neovim", ":qa<CR>"),
    }

    local function footer()
      -- Number of plugins
      local total_plugins = #vim.tbl_keys(require("lazy").plugins())
      local datetime = os.date "%d-%m-%Y  %H:%M:%S"
      local plugins_text = "\t" .. total_plugins .. " plugins  " .. datetime

      -- Quote
      local fortune = require "alpha.fortune"
      local quote = table.concat(fortune(), "\n")

      return plugins_text .. "\n" .. quote
    end

    dashboard.section.footer.val = footer()
    -- Define your own highlight groups
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#cc241d", bold = true }) -- Gruvbox red
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#ff8c00" })             -- dark orange
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#ff8c00", italic = true }) -- dark orange
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.buttons.opts.hl_shortcut = "Type"
    dashboard.opts.opts.noautocmd = true

    alpha.setup(dashboard.opts)
  end
}
