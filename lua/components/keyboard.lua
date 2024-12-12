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
			Cassiopea.sway.toggle_keyboard()
		end,
		Widget.Box({
			Revealer(
				"󰌌 ",
				Cassiopea.sway.keyboard(function(keyboard)
					return keyboard.enabled
				end)
			),
			Revealer(
				"󰌐 ",
				Cassiopea.sway.keyboard(function(keyboard)
					return not keyboard.enabled
				end)
			),
			Revealer(
				"en",
				Cassiopea.sway.keyboard(function(keyboard)
					return keyboard.layout == "en"
				end)
			),
			Revealer(
				"it",
				Cassiopea.sway.keyboard(function(keyboard)
					return keyboard.layout == "it"
				end)
			),
		}),
	})
end

return Keyboard
