local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable

local Widget = require("astal.gtk3.widget")

local M = {}

local MAX_TEMP = 6500
local SHIELD_TEMP = 5000

local temperature = Variable(MAX_TEMP):watch("wl-gammarelay-rs watch {t}", function(result)
	return tonumber(result)
end)

---@param current_temp number
---@return boolean
local function is_eyeshield_enabled(current_temp)
	return current_temp ~= MAX_TEMP
end

local function toggle_eye_shield()
	local new_temperature

	if is_eyeshield_enabled(temperature:get()) then
		new_temperature = MAX_TEMP
	else
		new_temperature = SHIELD_TEMP
	end

	astal.exec_async(
		string.format(
			"busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q %s",
			new_temperature
		)
	)
end

M.EyeShieldIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(temperature):as(function(value)
			return is_eyeshield_enabled(value) and "Enabled" or "Disabled"
		end),
		label = temperature(function(value)
			return is_eyeshield_enabled(value) and Cassiopea.icons.eye_shield.enabled
				or Cassiopea.icons.eye_shield.disabled
		end),
	})
end

M.ToggleEyeShield = function()
	return Widget.Button({
		class_name = temperature(function(value)
			local class_name = "toggle-button "
			return class_name .. (is_eyeshield_enabled(value) and "active" or "")
		end),
		on_clicked = function()
			toggle_eye_shield()
		end,
		Widget.Box({
			M.EyeShieldIcon(),
			Widget.Box({
				class_name = "text",
				Widget.Label({
					class_name = "title",
					label = temperature(function(value)
						return is_eyeshield_enabled(value) and "Enabled" or "Disabled"
					end),
				}),
			}),
		}),
	})
end

return M
