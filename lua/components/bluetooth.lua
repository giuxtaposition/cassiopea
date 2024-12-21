local astal = require("astal")
local bind = astal.bind
local Bluetooth = require("lgi").require("AstalBluetooth")
local Widget = require("astal.gtk3.widget")
local ToggleButton = require("lua.components.toggle_button")

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
		end)
	)
end

return M
