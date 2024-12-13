local astal = require("astal")
local bind = astal.bind
local Bluetooth = require("lgi").require("AstalBluetooth")
local Widget = require("astal.gtk3.widget")
local Gdk = astal.require("Gdk", "3.0")

local M = {}

local bluetooth = Bluetooth.get_default()

M.BluetoothIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(bluetooth, "devices"):as(function(devices)
			local connected_devices = Cassiopea.table.filter(devices, function(device)
				return device.connected
			end)
			if #connected_devices == 1 then
				return connected_devices[1].name
			end

			return #connected_devices .. " Connected"
		end),
		label = bind(bluetooth, "is_powered"):as(function(enabled)
			return enabled and Cassiopea.icons.bluetooth.enabled or Cassiopea.icons.bluetooth.disabled
		end),
	})
end

M.ToggleBluetooth = function()
	return Widget.Button({
		class_name = bind(bluetooth, "is_powered"):as(function(enabled)
			local class_name = "toggle-button "
			return class_name .. (enabled and "active" or "")
		end),
		on_clicked = function()
			bluetooth:toggle()
		end,
		on_button_press_event = function(_, event)
			if event.button == Gdk.BUTTON_SECONDARY then
				Cassiopea.windows.hide(Cassiopea.windows.window_name.quick_settings)
				astal.exec({ "bash", "-c", "blueman-manager" })
			end
		end,
		Widget.Box({
			M.BluetoothIcon(),
			Widget.Box({
				class_name = "text",
				Widget.Label({
					class_name = "title",
					label = bind(bluetooth, "devices"):as(function(devices)
						local connected_devices = Cassiopea.table.filter(devices, function(device)
							return device.connected
						end)
						if #connected_devices == 1 then
							return connected_devices[1].name
						end

						return #connected_devices .. " Connected"
					end),
				}),
			}),
		}),
	})
end

return M
