local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local Variable = astal.Variable

local function Avatar()
	local size = 45
	local img_url = Variable(""):watch("pwd", function(result)
		return result .. "/assets/user.jpg"
	end)

	return Widget.Box({
		class_name = "avatar",
		css = img_url(function(img)
			return string.format(
				[[
          min-width: %spx;
          min-height: %spx;
          background-image: url('%s');
          background-size: cover;
        ]],
				size,
				size,
				img
			)
		end),
	})
end

return Avatar
