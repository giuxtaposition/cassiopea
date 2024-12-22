local astal = require("astal")
local App = require("astal.gtk3.app")
local Widget = require("astal.gtk3.widget")
local Gdk = astal.require("Gdk", "3.0")
local Astal = astal.require("Astal", "3.0")
local PowerMenuButton = require("lua.components.power_menu_buttons").PowerMenuButton

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
			PowerMenuButton("poweroff", "Power off"),
			PowerMenuButton("reboot", "Reboot"),
			PowerMenuButton("lock", "Lock"),
			PowerMenuButton("suspend", "Suspend"),
			PowerMenuButton("signout", "Sign out"),
		}),
	})
end
