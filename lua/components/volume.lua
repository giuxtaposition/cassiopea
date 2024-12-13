local astal = require("astal")
local Wp = astal.require("AstalWp")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")

local M = {}
---@param type "speaker" | "microphone"
M.VolumeIcon = function(type)
	local volume = Wp.get_default().audio["default_" .. type]

	return Widget.Box({
		Widget.Revealer({
			transition_duration = 200,
			transition_type = "SLIDE_LEFT",
			reveal_child = bind(volume, "mute"):as(function(mute)
				return not mute
			end),
			Widget.Label({
				class_name = "indicator-icon",
				label = bind(volume, "volume"):as(function(v)
					return Cassiopea.icons.volume_icon(math.floor(v * 100), type)
				end),
				tooltip_text = bind(volume, "volume"):as(function(v)
					return tostring(math.floor(v * 100)) .. "%"
				end),
			}),
		}),
		Widget.Revealer({
			transition_duration = 200,
			transition_type = "SLIDE_LEFT",
			reveal_child = bind(volume, "mute"),
			Widget.Label({
				class_name = "indicator-icon",
				label = Cassiopea.icons.volume[type].muted,
				tooltip_text = bind(volume, "volume"):as(function(v)
					return tostring(math.floor(v * 100)) .. "%"
				end),
			}),
		}),
	})
end

---@param type "speaker" | "microphone"
M.VolumeSlider = function(type)
	local volume = Wp.get_default().audio["default_" .. type]

	return Widget.Overlay({
		hexpand = true,
		pass_through = true,
		Widget.Slider({
			draw_value = false,
			on_dragged = function(self)
				volume.volume = self.value
			end,
			value = bind(volume, "volume"),
			class_name = bind(volume, "mute"):as(function(mute)
				local class_name = "volume-slider "
				return class_name .. (mute and "mute" or "")
			end),
		}),
	})
end

---@param type "speaker" | "microphone"
M.VolumeMuteButton = function(type)
	local volume = Wp.get_default().audio["default_" .. type]

	return Widget.Button({
		on_clicked = function()
			volume.mute = not volume.mute
		end,
		class_name = bind(volume, "mute"):as(function(mute)
			local class_name = "volume-mute "
			return class_name .. (mute and "active" or "")
		end),

		Widget.Label({
			label = Cassiopea.icons.volume[type].muted,
		}),
	})
end

---@param type "speaker" | "microphone"
M.VolumeSliderAndMuteButton = function(type)
	return Widget.Box({
		class_name = "volume",
		M.VolumeSlider(type),
		M.VolumeMuteButton(type),
	})
end

return M
