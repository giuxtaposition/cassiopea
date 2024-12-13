local Widget = require("astal.gtk3.widget")

local function Avatar()
	local size = 45
	local img = "/home/giu/Programming/cassiopea/assets/user.jpg" --FIXME : should not be hardcoded

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
			img
		),
	})
end

return Avatar
