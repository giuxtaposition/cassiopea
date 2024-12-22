local astal = require("astal")
local Widget = require("astal.gtk3.widget")

local M = {}

M.actions = {
	poweroff = "systemctl poweroff",
	reboot = "systemctl reboot",
	lock = "sleep 0.1 && swaylock",
	suspend = "sleep 0.1 && swaylock & systemctl suspend",
	signout = "niri msg action quit",
}

---@param action string
---@param label? string
M.PowerMenuButton = function(action, label)
	return Widget.Box({
		hexpand = true,
		vexpand = true,
		vertical = true,
		valign = "CENTER",
		class_name = "power-menu-entry",
		Widget.Button({
			on_clicked = function()
				Cassiopea.windows.hide(Cassiopea.windows.window_name.power_menu)
				astal.exec(string.format('bash -c "%s"', M.actions[action]))
			end,
			Widget.Box({
				vertical = true,
				class_name = "system-button",
				Widget.Label({
					label = Cassiopea.icons.power_menu[action],
				}),
			}),
		}),
		label and Widget.Label({
			label = label,
			class_name = "label",
		}) or nil,
	})
end

M.PowerMenuButtons = function()
	return Widget.Box({
		class_name = "power-menu-buttons",
		spacing = 8,
		M.PowerMenuButton("poweroff"),
		M.PowerMenuButton("reboot"),
		M.PowerMenuButton("suspend"),
	})
end

return M
