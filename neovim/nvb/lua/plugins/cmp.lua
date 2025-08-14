-- Completion
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  -- event = "VimEnter",
  opt = true,
  config = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    local luasnip = require "luasnip"
    local cmp = require "cmp"

    cmp.setup {
      completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
      experimental = { native_menu = false, ghost_text = false },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            buffer = "[Buffer]",
            luasnip = "[Snip]",
            nvim_lua = "[Lua]",
            treesitter = "[Treesitter]",
          })[entry.source.name]
          return vim_item
        end,
      },
      mapping = {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
        ["<CR>"] = cmp.mapping {
          i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          c = function(fallback)
            if cmp.visible() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
              fallback()
            end
          end,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, {
          "i",
          "s",
          "c",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
          "c",
        }),
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          -- TODO: add conditional for this 
          -- require("copilot_cmp.comparators").prioritize,

          -- Below is the default comparitor list and order for nvim-cmp
          cmp.config.compare.offset,
          -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      sources = {
        { name = "copilot" },
        { name = "treesitter" },
        { name = "buffer" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "spell" },
        { name = "emoji" },
        { name = "calc" },
      },
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
        },
      }
    }

    -- Use buffer source for `/`
    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- Auto pairs
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
  end,
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    -- "zbirenbaum/copilot-cmp",
    "ray-x/cmp-treesitter",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-calc",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-emoji",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  -- dependencies = vim.tbl_filter(function(plugin)
      -- TODO: fix this
      -- Check if the plugin is 'zbinrenbaum/copilot-cmp' and whehter PLUGINS.copilot.enabled is true
      -- if type(plugin) == "string" and plugin == "zbirenbaum/copilot-cmp" then
      --   return PLUGINS.copilot.enabled
      -- end
      -- return true
    -- end, 
  -- }),
}
