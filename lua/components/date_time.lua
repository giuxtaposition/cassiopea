local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local GLib = astal.require("GLib")
local Variable = astal.Variable

local function DateTime(format)
	local time = Variable(""):poll(1000, function()
		return GLib.DateTime.new_now_local():format(format)
	end)

	return Widget.Label({
		class_name = "date-time",
		on_destroy = function()
			time:drop()
		end,
		label = time(),
	})
end

return DateTime
