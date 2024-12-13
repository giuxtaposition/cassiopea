local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local Wp = astal.require("AstalWp")
local Battery = astal.require("AstalBattery")
local bind = astal.bind

local NetworkIcon = require("lua.components.network").NetworkIcon
local DateTime = require("lua.components.date_time")

---@param type "speaker" | "microphone"
local function VolumeIcon(type)
	local speaker = Wp.get_default().audio["default_" .. type]

	return Widget.Box({
		Widget.Revealer({
			transition_duration = 200,
			transition_type = "SLIDE_LEFT",
			reveal_child = bind(speaker, "mute"):as(function(mute)
				return not mute
			end),
			Widget.Label({
				class_name = "indicator-icon",
				label = bind(speaker, "volume"):as(function(v)
					return Cassiopea.icons.volume_icon(math.floor(v * 100), type)
				end),
				tooltip_text = bind(speaker, "volume"):as(function(v)
					return tostring(math.floor(v * 100)) .. "%"
				end),
			}),
		}),
		Widget.Revealer({
			transition_duration = 200,
			transition_type = "SLIDE_LEFT",
			reveal_child = bind(speaker, "mute"),
			Widget.Label({
				class_name = "indicator-icon",
				label = Cassiopea.icons.volume[type].muted,
				tooltip_text = bind(speaker, "volume"):as(function(v)
					return tostring(math.floor(v * 100)) .. "%"
				end),
			}),
		}),
	})
end

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
