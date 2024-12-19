local astal = require("astal")
local App = require("astal.gtk3.app")
local Widget = require("astal.gtk3.widget")
local Gdk = astal.require("Gdk", "3.0")
local Astal = astal.require("Astal", "3.0")

---@param action string
---@param label string
---@param icon string
local function SysButton(action, label, icon)
	return Widget.Box({
		hexpand = true,
		vexpand = true,
		vertical = true,
		class_name = "power-menu-entry",
		Widget.Button({
			on_clicked = function()
				local cmd = {
					poweroff = "systemctl poweroff",
					reboot = "systemctl reboot",
					lock = "sleep 0.1 && swaylock",
					suspend = "sleep 0.1 && swaylock & systemctl suspend",
					signout = "niri msg action quit",
				}

				Cassiopea.windows.hide(Cassiopea.windows.window_name.power_menu)
				astal.exec(string.format('bash -c "%s"', cmd[action]))
			end,
			Widget.Box({
				vertical = true,
				class_name = "system-button",
				Widget.Label({
					label = icon,
				}),
			}),
		}),
		Widget.Label({
			label = label,
			class_name = "label",
		}),
	})
end

return function()
	return Widget.Window({
		name = Cassiopea.windows.window_name.power_menu,
		visible = false,
		exclusivity = Astal.Exclusivity.EXCLUSIVE,
		keymode = Astal.Keymode.EXCLUSIVE,
		application = App,
		setup = function(self)
			App:add_window(self)
		end,
		on_key_press_event = function(self, event)
			if event:get_keyval() == Gdk.KEY_Escape then
				self:hide()
			end
		end,
		Widget.Box({
			class_name = "power-menu",
			SysButton("poweroff", "Power off", ""),
			SysButton("reboot", "Reboot", "󰜉"),
			SysButton("lock", "Lock", ""),
			SysButton("suspend", "Suspend", "󰤄"),
			SysButton("signout", "Sign out", "󰗼"),
		}),
	})
end
