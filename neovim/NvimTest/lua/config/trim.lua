local M = {}

local trim = require("trim")

function M.setup()
	trim.setup({
		ft_blocklist = {},
		patterns = {},
		trim_on_write = true,
		trim_trailing = true,
		trim_last_line = false,
		trim_first_line = false,
		highlight = false,
		highlight_bg = 'red',
	})
end

return M
