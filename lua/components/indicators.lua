local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local Battery = astal.require("AstalBattery")
local bind = astal.bind

local NetworkIcon = require("lua.components.network").NetworkIcon
local DateTime = require("lua.components.date_time")
local VolumeIcon = require("lua.components.volume").VolumeIcon

local function BatteryLevel()
	local bat = Battery.get_default()

	return Widget.Label({
		class_name = "indicator-icon",
		label = bind(bat, "battery-icon-name"):as(function(battery_icon_name)
			return Cassiopea.icons.battery[battery_icon_name]
		end),
		visible = bind(bat, "is-present"),
		tooltip_text = bind(bat, "percentage"):as(function(p)
			return tostring(math.floor(p * 100)) .. " %"
		end),
	})
end

local function Indicators()
	return Widget.Button({
		class_name = "indicators",
		on_clicked = function()
			Cassiopea.windows.toggle(Cassiopea.windows.window_name.quick_settings)
		end,
		Widget.Box({
			NetworkIcon(),
			VolumeIcon("speaker"),
			VolumeIcon("microphone"),
			BatteryLevel(),
			DateTime("%H:%M"),
		}),
	})
end

return Indicators
