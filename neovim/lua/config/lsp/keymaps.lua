local M = {}

function M.setup(client, bufnr)
  local whichkey = require "which-key"
  -- error("Trigger test error")

  local keymap = vim.api.nvim_set_keymap
  local buf_keymap = vim.api.nvim_buf_set_keymap

  local opts = { noremap = true, silent = true }
	-- Try NEW
	-- For normal mode
	-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	-- -- For normal and visual mode
	-- vim.keymap.set({"n", "v"}, "K", vim.lsp.buf.hover, { buffer = 0 })

	-- Key mappings
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

  -- Whichkey
  local lsp_mappings = {
    { "<leader>l", group = "Code"},
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename"},
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action"},
    { "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Line Diagnostics"},
    { "<leader>li", "<cmd>LspInfo<CR>", desc = "Lsp Info"},
    prefix = "<leader>",
    nowait = false,
    noremap = true,
    buffer = bufnr,
  }
  if client.server_capabilities.documentFormattingProvider then
    table.insert(lsp_mappings, { "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", desc = "Format Document"})
  end

  local keymap_g = {
    { "g", group = "Goto"},
    { "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definition"},
    { "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration"},
    { "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature Help"},
    { "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Goto Implementation"},
    { "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto Type Definition"},
    prefix = "g",
    buffer = bufnr,
    nowait = false,
    noremap = true,
  }
  whichkey.add(lsp_mappings)
  whichkey.add(keymap_g)
end

-- function M.setup(client, bufnr)
--   keymappings(client, bufnr)
-- end

return M
