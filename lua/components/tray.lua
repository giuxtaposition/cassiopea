local ToggleWindowButton = require("lua.components.toggle_window_button")

local function Tray()
	return ToggleWindowButton("", "tray-button", Cassiopea.windows.window_name.systray)
end

return Tray
