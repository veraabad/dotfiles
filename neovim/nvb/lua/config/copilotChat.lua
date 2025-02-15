local M = {}

function M.setup()
  local copilotChat = require('CopilotChat')
  local config = {
    debug = true,
    -- Add more configurations here
  }
  copilotChat.setup(config)
end

return M
