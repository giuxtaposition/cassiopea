local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Network = astal.require("AstalNetwork")
local Widget = require("astal.gtk3.widget")
local ToggleButton = require("lua.components.toggle_button")

local M = {}
local wifi = Network.get_default().wifi
local show_network_list = Variable(false)

M.NetworkIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(wifi, "ssid"):as(tostring),
		label = bind(wifi, "icon-name"):as(function(icon_name)
			return Cassiopea.icons.network[icon_name]
		end),
	})
end

local filter_without_ssid = function(list)
	return Cassiopea.table.filter(list, function(ap)
		return ap.ssid ~= nil
	end)
end

local function remove_duplicates(list)
	local seen = {}
	local result = {}
	for _, item in ipairs(list) do
		if item.ssid and not seen[item.ssid] then
			table.insert(result, item)
			seen[item.ssid] = true
		end
	end
	return result
end

local sort_by_priority = function(list)
	table.sort(list, function(a, b)
		if a.ssid == wifi.active_access_point.ssid then
			return true
		end

		if b.ssid == wifi.active_access_point.ssid then
			return false
		end
		return a.strength > b.strength
	end)
end

local function keep_first_n(list, n)
	local result = {}
	for i = 1, math.min(n, #list) do
		table.insert(result, list[i])
	end
	return result
end

local connect_to_access_point = function(access_point)
	if access_point == wifi.active_access_point.ssid then
		return
	end
	astal.exec_async(string.format("nmcli device wifi connect %s", access_point.bssid))
end

M.NetworkList = function()
	if wifi == nil then
		return
	end

	return Widget.Revealer({
		transition_duration = 200,
		transition_type = "SLIDE_DOWN",
		reveal_child = show_network_list(function(value)
			return value
		end),
		Widget.Box({
			class_name = "network-list",
			vertical = true,
			bind(wifi, "access_points"):as(function(access_points)
				local list = filter_without_ssid(access_points)
				list = remove_duplicates(list)
				sort_by_priority(list)
				list = keep_first_n(list, 3)
				return Cassiopea.table.map(list, function(item)
					return Widget.Button({
						class_name = "network-item",
						on_clicked = function()
							connect_to_access_point(item)
						end,
						Widget.Box({
							class_name = "text",
							Widget.Label({
								class_name = "icon",
								label = bind(item, "icon-name"):as(function(icon_name)
									return Cassiopea.icons.network[icon_name]
								end),
							}),
							Widget.Label({
								label = bind(item, "ssid"):as(tostring),
							}),
						}),
					})
				end)
			end),
		}),
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
		end),
		function()
			if show_network_list:get() then
				show_network_list:set(false)
			else
				show_network_list:set(true)
			end
		end
	)
end

return M
