local Widget = require("astal.gtk3.widget")

ToggleButton = function(active_binding, on_click, icon, title, subtitle, secondary_action)
	return Widget.Box({
		class_name = active_binding:as(function(active)
			local class_name = "toggle-button "
			return class_name .. (active and "active" or "")
		end),
		Widget.Button({
			expand = true,
			class_name = string.format("primary-action %s", secondary_action ~= nil and "has-secondary-action" or ""),
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
		}),
		secondary_action ~= nil and Widget.Button({
			on_clicked = secondary_action,
			class_name = "secondary-action",
			Widget.Label({
				label = "",
			}),
		}) or nil,
	})
end

return ToggleButton
