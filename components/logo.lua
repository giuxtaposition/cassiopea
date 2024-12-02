local Widget = require("astal.gtk3.widget")
local windows = require("lib.windows")

local function Logo()
	return Widget.Button({
		class_name = "logo",
		on_click_release = function()
			windows.show(windows.window_name.launcher)
		end,
		Widget.Label({
			label = "",
		}),
	})
end

return Logo
