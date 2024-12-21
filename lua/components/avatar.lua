local Widget = require("astal.gtk3.widget")
local GLib = require("lgi").require("GLib")
local avatar_path = GLib.getenv("CASSIOPEA_AVATAR_PATH")

local function Avatar()
	local size = 45
	print(avatar_path)

	return Widget.Box({
		class_name = "avatar",
		css = string.format(
			[[
          min-width: %spx;
          min-height: %spx;
          background-image: url('%s');
          background-size: cover;
        ]],
			size,
			size,
			avatar_path
		),
	})
end

return Avatar
