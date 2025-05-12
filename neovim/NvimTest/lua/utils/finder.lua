local M = {}

-- Custom find buffers function.
function M.find_buffers()
  local results = {}
  local buffers = vim.api.nvim_list_bufs()

  for _, buffer in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local filename = vim.api.nvim_buf_get_name(buffer)
      table.insert(results, filename)
    end
  end

  vim.ui.select(results, { prompt = "Find buffer:" }, function(selected)
    if selected then
      vim.api.nvim_command("buffer " .. selected)
    end
  end)
end

-- Find actual root directory of git repo
local function get_repo_root()
  local Job = require("plenary.job")
  local cwd = vim.fn.getcwd()
  -- If we are in one of the submodules, use the root repo as the CWD
  local superproject = Job:new({
    command = "git",
    args = { "rev-parse", "--show-superproject-working-tree"},
    cwd = cwd,
  }):sync()[1]

  -- Will fail if not in a superproject. 
  if superproject and #superproject > 0 then
    return superproject
  end

  local root = Job:new({
    command = "git",
    args = { "rev-parse", "--show-toplevel"},
    cwd = cwd,
  }):sync()[1]
  return root
end

function M.find_files()
  local opts = {
    recurse_submodules = true,
    cwd = get_repo_root(),
  }
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.find_functions()
  local opts = {
    ignore_symbols = {"variable"},
  }
  local telescope = require "telescope.builtin"
  telescope.lsp_document_symbols(opts)
end

-- Find dotfiles
function M.find_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "<Dotfiles>",
    cwd = "$HOME/.dotfiles/",
  }
end

function M.open_ssh_config()
  local ssh_config_path = "$HOME/.ssh/config"
  vim.cmd("edit".. ssh_config_path)
end

-- local fzf = require "fzf-lua"
-- if vim.fn.system "git rev-parse --is-inside-work-tree" == true then
  --   fzf.git_files()
  -- else
  --   fzf.files()
  -- end

return M
