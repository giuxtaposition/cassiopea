local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Logo = require("lua.components.logo")

return function(gdkmonitor)
	local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

	return Widget.Window({
		class_name = "bar",
		hexpand = true,
		gdkmonitor = gdkmonitor,
		anchor = WindowAnchor.TOP + WindowAnchor.LEFT + WindowAnchor.RIGHT,
		exclusivity = "EXCLUSIVE",
		Widget.CenterBox({
			Widget.Box({
				halign = "START",
				hexpand = true,
				spacing = 12,
				Logo(),
				-- Workspaces(),
				-- FocusedClient(),
			}),
			Widget.Box({
				Widget.Label({
					label = "",
				}),
			}),
			Widget.Box({
				halign = "END",
				Widget.Label({
					label = "",
				}),
			}),
		}),
	})
end
