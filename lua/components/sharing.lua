local Widget = require("astal.gtk3.widget")

local M = {}

---@param icon string
local function SharingIndicator(icon, getter)
	return Widget.Label({
		class_name = "sharing",
		label = getter(function(sharing)
			if sharing then
				return icon
			else
				return ""
			end
		end),
	})
end

M.ScreenSharingIndicator = function()
	return SharingIndicator("󱄄", Cassiopea.sharing.screen_sharing)
end

M.MicRecordingIndicator = function()
	return SharingIndicator("", Cassiopea.sharing.mic_recording)
end

M.WebcamRecordingIndicator = function()
	return SharingIndicator("", Cassiopea.sharing.webcam_recording)
end

return M
