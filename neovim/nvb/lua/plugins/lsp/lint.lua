return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = {'pylint'}
    }
    local pylint = lint.linters.pylint
    pylint.cmd = 'python'
    table.insert(pylint.args, 1, 'pylint')
    table.insert(pylint.args, 1, '-m')
    vim.api.nvim_create_autocmd({"BufWritePost"}, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
