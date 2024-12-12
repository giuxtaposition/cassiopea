---@class cassiopea.lib.icons
local M = {}

M.volume = {
	microphone = {
		muted = "󰍭",
		volume = { "󰍬", "󰍬", "󰍬" },
	},
	speaker = {
		muted = "󰸈",
		volume = { " ", " ", " " },
	},
}

---@param volume number
---@param type "speaker" | "microphone"
---@return string
M.volume_icon = function(volume, type)
	local i = M.volume[type]
	if volume < 33 then
		return i.volume[1]
	elseif volume < 67 then
		return i.volume[2]
	else
		return i.volume[3]
	end
end

M.network = {
	["network-wireless-acquiring-symbolic"] = "󰤯",
	["network-wireless-disabled-symbolic"] = "󰤭",
	["network-wireless-offline-symbolic"] = "󰤩",
	["network-wireless-signal-excellent-symbolic"] = "󰤨",
	["network-wireless-signal-good-symbolic"] = "󰤥",
	["network-wireless-signal-ok-symbolic"] = "󰤢",
	["network-wireless-signal-weak-symbolic"] = "󰤟",
	["network-wireless-signal-none-symbolic"] = "󰤯",
}

M.battery = {
	["battery-level-100-charged-symbolic"] = "󰂅",
	["battery-level-90-charging-symbolic"] = "󰂋",
	["battery-level-80-charging-symbolic"] = "󰂊",
	["battery-level-70-charging-symbolic"] = "󰂉",
	["battery-level-60-charging-symbolic"] = "󰂉",
	["battery-level-50-charging-symbolic"] = "󰢝",
	["battery-level-40-charging-symbolic"] = "󰂈",
	["battery-level-30-charging-symbolic"] = "󰂇",
	["battery-level-20-charging-symbolic"] = "󰂆",
	["battery-level-10-charging-symbolic"] = "󰢜",
	["battery-level-100-symbolic"] = "󰁹",
	["battery-level-90-symbolic"] = "󰂂",
	["battery-level-80-symbolic"] = "󰂂",
	["battery-level-70-symbolic"] = "󰂂",
	["battery-level-60-symbolic"] = "󰁿",
	["battery-level-50-symbolic"] = "󰁿",
	["battery-level-40-symbolic"] = "󰁿",
	["battery-level-30-symbolic"] = "󰁿",
	["battery-level-20-symbolic"] = "󰁻",
	["battery-level-10-symbolic"] = "󰁻",
	["battery-level-0-symbolic"] = "󰂎",
}

return M
