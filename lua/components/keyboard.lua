local Widget = require("astal.gtk3.widget")

local function Revealer(label, reveal_child_condition)
	return Widget.Revealer({
		transition_duration = 200,
		transition_type = "SLIDE_LEFT",
		reveal_child = reveal_child_condition,
		Widget.Label({
			label = label,
		}),
	})
end

local function Keyboard()
	return Widget.Button({
		class_name = "keyboard",
		on_clicked = function()
			Cassiopea.niri.switch_keyboard_layout()
		end,
		Widget.Box({
			Widget.Label({
				label = "󰌌 ",
			}),
			Revealer(
				"en",
				Cassiopea.niri.keyboard_layout(function(layout)
					return layout == "en"
				end)
			),
			Revealer(
				"it",
				Cassiopea.niri.keyboard_layout(function(layout)
					return layout == "it"
				end)
			),
		}),
	})
end

return Keyboard
