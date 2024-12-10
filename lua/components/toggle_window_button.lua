local Widget = require("astal.gtk3.widget")
local windows = require("lua.lib.windows")

---@param icon string
---@param class_name string
---@param window_name string
local function ToggleWindowButton(icon, class_name, window_name)
	return Widget.Button({
		class_name = class_name,
		on_click_release = function()
			windows.toggle(window_name)
		end,
		Widget.Label({
			label = icon,
		}),
	})
end

return ToggleWindowButton
