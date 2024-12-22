local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")
local ToggleButton = require("lua.components.toggle_button")

local M = {}

local MAX_TEMP = 6500
local SHIELD_TEMP = 5000

local night_light_enabled = Variable(false):watch("wl-gammarelay-rs watch {t}", function(result)
	return tonumber(result) ~= MAX_TEMP
end)

local function toggle_night_light()
	local new_temperature

	if night_light_enabled:get() then
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

M.NightLightIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(night_light_enabled):as(function(enabled)
			return enabled and "Enabled" or "Disabled"
		end),
		label = night_light_enabled(function(enabled)
			return enabled and Cassiopea.icons.night_light.enabled or Cassiopea.icons.night_light.disabled
		end),
	})
end

M.ToggleNightLight = function()
	return ToggleButton(
		bind(night_light_enabled),
		function()
			toggle_night_light()
		end,
		M.NightLightIcon(),
		"Night Light",
		night_light_enabled(function(enabled)
			return enabled and "Enabled" or "Disabled"
		end)
	)
end

return M
