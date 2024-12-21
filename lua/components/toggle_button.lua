local Widget = require("astal.gtk3.widget")

ToggleButton = function(active_binding, on_click, icon, title, subtitle)
	return Widget.Button({
		class_name = active_binding:as(function(active)
			local class_name = "toggle-button "
			return class_name .. (active and "active" or "")
		end),
		on_clicked = on_click,
		Widget.Box({
			icon,
			Widget.Box({
				vertical = true,
				class_name = "text",
				Widget.Label({
					halign = "START",
					class_name = "title",
					label = title,
				}),
				Widget.Label({
					halign = "START",
					class_name = "subtitle",
					label = subtitle,
				}),
			}),
		}),
	})
end

return ToggleButton
