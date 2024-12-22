local astal = require("astal")
local Wp = astal.require("AstalWp")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local M = {}
local show_speaker_devices_list = Variable(false)
local show_microphone_devices_list = Variable(false)

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

	return Widget.Box({
		class_name = "volume-slider",
		hexpand = true,
		Widget.Slider({
			hexpand = true,
			draw_value = false,
			on_dragged = function(self)
				volume.volume = self.value
			end,
			value = bind(volume, "volume"),
			class_name = bind(volume, "mute"):as(function(mute)
				return (mute and "muted" or "")
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
			local class_name = "volume-button "
			return class_name .. (mute and "active" or "")
		end),

		Widget.Label({
			label = bind(volume, "mute"):as(function(mute)
				return mute and Cassiopea.icons.volume[type].muted or Cassiopea.icons.volume[type].volume[3]
			end),
		}),
	})
end

---@param type "speaker" | "microphone"
M.ShowDeviceListButton = function(type)
	return Widget.Button({
		on_clicked = function()
			if type == "speaker" then
				show_speaker_devices_list:set(not show_speaker_devices_list:get())
			else
				show_microphone_devices_list:set(not show_microphone_devices_list:get())
			end
		end,
		class_name = "volume-button",
		Widget.Label({
			label = "",
		}),
	})
end

---@param type "speaker" | "microphone" --TODO
M.DeviceList = function(type)
	local audio = Wp.get_default().audio
	local reveal_child_binding = type == "speaker" and show_speaker_devices_list or show_microphone_devices_list

	return Widget.Revealer({
		transition_duration = 200,
		transition_type = "SLIDE_DOWN",
		reveal_child = reveal_child_binding(),
		Widget.Box({
			class_name = "device-list",
			vertical = true,
			bind(audio, type .. "s"):as(function(speakers)
				if not speakers then
					return
				end

				return Cassiopea.table.map(speakers, function(item)
					return Widget.Button({
						class_name = "device-item",
						on_clicked = function()
							item:set_is_default(true)
						end,
						Widget.Box({
							class_name = bind(audio["default_" .. type], "id"):as(function(id)
								return id == item.id and "active" or ""
							end),
							Widget.Label({
								class_name = "icon",
								label = Cassiopea.icons.volume.speaker.volume[3],
							}),
							Widget.Label({
								label = bind(item, "description"):as(function(description)
									return Cassiopea.string.truncate(description, 45)
								end),
								tooltip_text = bind(item, "description"),
							}),
						}),
					})
				end)
			end),
		}),
	})
end

---@param type "speaker" | "microphone"
M.VolumeSliderAndMuteButton = function(type)
	return Widget.Box({
		class_name = "volume",
		vertical = true,
		Widget.Box({
			M.VolumeIcon(type),
			M.VolumeSlider(type),
			M.VolumeMuteButton(type),
			M.ShowDeviceListButton(type),
		}),
		M.DeviceList(type),
	})
end

return M
