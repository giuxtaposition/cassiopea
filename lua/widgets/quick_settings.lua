local astal = require("astal")
local App = require("astal.gtk3.app")
local Widget = require("astal.gtk3.widget")
local Gdk = astal.require("Gdk", "3.0")
local Astal = astal.require("Astal", "3.0")
local Avatar = require("lua.components.avatar")
local PowerMenuButtons = require("lua.components.power_menu_buttons").PowerMenuButtons
local DateTime = require("lua.components.date_time")
local ToggleNetwork = require("lua.components.network").ToggleNetwork
local NetworkList = require("lua.components.network").NetworkList
local ToggleBluetooth = require("lua.components.bluetooth").ToggleBluetooth
local BluetoothDevicesList = require("lua.components.bluetooth").BluetoothDevicesList
local ToggleDoNotDisturb = require("lua.components.do_not_disturb").ToggleDoNotDisturb
local ToggleNightLight = require("lua.components.night_light").ToggleNightLight
local VolumeSliderAndMuteButton = require("lua.components.volume").VolumeSliderAndMuteButton
local Player = require("lua.components.player").Player

return function()
	return Widget.Window({
		name = Cassiopea.windows.window_name.quick_settings,
		visible = false,
		anchor = Astal.WindowAnchor.TOP + Astal.WindowAnchor.RIGHT,
		exclusivity = Astal.Exclusivity.EXCLUSIVE,
		keymode = Astal.Keymode.ON_DEMAND,
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
			class_name = "quick-settings",
			vertical = true,
			spacing = 16,
			Widget.Box({
				hexpand = true,
				Avatar(),
				PowerMenuButtons(),
				DateTime("%H:%M | %a, %b %d"),
			}),
			Widget.Box({
				vertical = true,
				spacing = 8,
				Widget.Box({
					class_name = "row",
					spacing = 8,
					homogeneous = true,
					ToggleNetwork(),
					ToggleBluetooth(),
				}),
				NetworkList(),
				BluetoothDevicesList(),
			}),
			Widget.Box({
				homogeneous = true,
				spacing = 8,
				class_name = "row",
				ToggleDoNotDisturb(),
				ToggleNightLight(),
			}),
			VolumeSliderAndMuteButton("speaker"),
			VolumeSliderAndMuteButton("microphone"),
			Player(),
		}),
	})
end
