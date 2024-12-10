local ToggleWindowButton = require("lua.components.toggle_window_button")

local function Logo()
	return ToggleWindowButton("", "logo", Cassiopea.windows.window_name.launcher)
end

return Logo
