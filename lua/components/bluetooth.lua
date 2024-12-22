local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Bluetooth = require("lgi").require("AstalBluetooth")
local Widget = require("astal.gtk3.widget")
local ToggleButton = require("lua.components.toggle_button")

local M = {}

local bluetooth = Bluetooth.get_default()
local show_devices_list = Variable(false)

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
	return ToggleButton(
		bind(bluetooth, "is_powered"),
		function()
			bluetooth:toggle()
		end,
		M.BluetoothIcon(),
		"Bluetooth",
		bind(bluetooth, "devices"):as(function(devices)
			local connected_devices = Cassiopea.table.filter(devices, function(device)
				return device.connected
			end)
			if #connected_devices == 1 then
				return connected_devices[1].name
			end

			return #connected_devices .. " Connected"
		end),
		function()
			show_devices_list:set(not show_devices_list:get())
		end
	)
end

M.BluetoothDevicesList = function()
	return Widget.Revealer({
		transition_duration = 200,
		transition_type = "SLIDE_DOWN",
		reveal_child = show_devices_list(),
		Widget.Box({
			class_name = "device-list",
			vertical = true,
			bind(bluetooth, "devices"):as(function(devices)
				if not devices then
					return
				end

				return Cassiopea.table.map(devices, function(item)
					return Widget.Button({
						class_name = "device-item",
						on_clicked = function()
							item:connect_device()
						end,
						Widget.Box({
							class_name = bind(item, "connected"):as(function(connected)
								return connected and "active" or ""
							end),
							Widget.Label({
								class_name = "icon",
								label = Cassiopea.icons.bluetooth.enabled,
							}),
							Widget.Label({
								label = bind(item, "name"):as(function(description)
									return Cassiopea.string.truncate(description, 45)
								end),
								tooltip_text = bind(item, "name"),
							}),
						}),
					})
				end)
			end),
		}),
	})
end

return M
