local astal = require("astal")
local bind = astal.bind
local Network = astal.require("AstalNetwork")
local Widget = require("astal.gtk3.widget")

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
	return Widget.Button({
		-- setup = function(self)
		-- 	self:hook(wifi, "state-changed", function()
		-- 		if wifi.enabled then
		-- 			print("wifi enabled")
		-- 			self:toggle_class_name("active")
		-- 		end
		--
		-- 		self:toggle_class_name("active")
		-- 	end)
		-- end,
		class_name = bind(wifi, "enabled"):as(function(enabled)
			local class_name = "toggle-button "
			return class_name .. (enabled and "active" or "")
		end),
		on_clicked = function()
			if wifi.enabled then
				wifi.enabled = false
			else
				wifi.enabled = true
				wifi:connect()
			end
		end,
		Widget.Box({
			M.NetworkIcon(),
			Widget.Box({
				class_name = "text",
				Widget.Label({
					class_name = "title",
					label = bind(wifi, "ssid"):as(function(ssid)
						return ssid or "Not Connected"
					end),
				}),
			}),
		}),
	})
end

return M
