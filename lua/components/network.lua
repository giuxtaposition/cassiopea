local astal = require("astal")
local bind = astal.bind
local Network = astal.require("AstalNetwork")
local Widget = require("astal.gtk3.widget")
local ToggleButton = require("lua.components.toggle_button")

local M = {}
local wifi = Network.get_default().wifi

M.NetworkIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(wifi, "ssid"):as(tostring),
		label = bind(wifi, "icon-name"):as(function(icon_name)
			return Cassiopea.icons.network[icon_name]
		end),
	})
end

M.ToggleNetwork = function()
	return ToggleButton(
		bind(wifi, "enabled"),
		function()
			if wifi.enabled then
				wifi.enabled = false
			else
				wifi.enabled = true
				wifi:connect()
			end
		end,
		M.NetworkIcon(),
		"Wi-Fi",
		bind(wifi, "ssid"):as(function(ssid)
			return ssid or "Not Connected"
		end)
	)
end

return M
