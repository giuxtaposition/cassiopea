local App = require("astal.gtk3.app")

local M = {
	window_name = {
		launcher = "launcher",
		bar = "bar",
	},
}

---@param window_name string
M.show = function(window_name)
	App:get_window(window_name):show()
end

---@param window_name string
M.hide = function(window_name)
	App:get_window(window_name):hide()
end

return M
