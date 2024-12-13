local Widget = require("astal.gtk3.widget")

---@param label string
---@param class_name string
---@param window_name string
local function ToggleWindowButton(label, class_name, window_name)
	return Widget.Button({
		class_name = class_name,
		on_click_release = function()
			Cassiopea.windows.toggle(window_name)
		end,
		Widget.Label({
			label = label,
		}),
	})
end

return ToggleWindowButton
