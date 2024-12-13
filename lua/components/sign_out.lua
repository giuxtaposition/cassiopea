local ToggleWindowButton = require("lua.components.toggle_window_button")

local function SignOut()
	return ToggleWindowButton("Sign Out", "sign-out", Cassiopea.windows.window_name.power_menu)
end

return SignOut
