local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local window_name = Cassiopea.windows.window_name.bar

local Logo = require("lua.components.logo")
local Workspaces = require("lua.components.workspaces")
local ScreenSharingIndicator = require("lua.components.sharing").ScreenSharingIndicator
local MicRecordingIndicator = require("lua.components.sharing").MicRecordingIndicator
local WebcamRecordingIndicator = require("lua.components.sharing").WebcamRecordingIndicator
local Tray = require("lua.components.tray")
local Keyboard = require("lua.components.keyboard")
local Indicators = require("lua.components.indicators")
local DateTime = require("lua.components.date_time")
local SpotifyIndicator = require("lua.components.player").SpotifyIndicator

return function(gdkmonitor)
	local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

	return Widget.Window({
		name = window_name,
		hexpand = true,
		gdkmonitor = gdkmonitor,
		anchor = WindowAnchor.TOP + WindowAnchor.LEFT + WindowAnchor.RIGHT,
		exclusivity = "EXCLUSIVE",
		Widget.CenterBox({
			Widget.Box({
				halign = "START",
				hexpand = true,
				spacing = 12,
				Logo(),
				Workspaces(),
			}),
			Widget.Box({
				DateTime("%H:%M - %A %d"),
				SpotifyIndicator(),
			}),
			Widget.Box({
				halign = "END",
				ScreenSharingIndicator(),
				MicRecordingIndicator(),
				WebcamRecordingIndicator(),
				Tray(),
				Keyboard(),
				Indicators(),
			}),
		}),
	})
end
