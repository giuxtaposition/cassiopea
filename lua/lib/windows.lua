local App = require("astal.gtk3.app")

---@class cassiopea.lib.windows
local M = {
	window_name = {
		launcher = "launcher",
		bar = "bar",
		systray = "systray",
		quick_settings = "quick-settings",
		power_menu = "power_menu",
		notifications = "notifications",
	},
}

M.toggle = function(window_name)
	if App:get_window(window_name).visible then
		M.hide(window_name)
	else
		M.show(window_name)
	end
end

---@param window_name string
M.show = function(window_name)
	App:get_window(window_name):show()
end

---@param window_name string
M.hide = function(window_name)
	App:get_window(window_name):hide()
end

return M
