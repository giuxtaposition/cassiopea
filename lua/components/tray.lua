local Widget = require("astal.gtk3.widget")
local Tray = require("lgi").require("AstalTray")
local tray = Tray.get_default()
local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable

local function Systray()
	local show_systray = Variable(false)

	return Widget.Box({
		class_name = "systray",
		Widget.Button({
			class_name = "tray-button",
			on_click = function()
				show_systray:set(not show_systray:get())
			end,
			Widget.Label({
				label = show_systray(function(show)
					return show and "" or ""
				end),
			}),
		}),
		Widget.Revealer({
			transition_duration = 200,
			transition_type = "SLIDE_LEFT",
			reveal_child = show_systray(),
			Widget.Box({
				class_name = "systray-items",
				bind(tray, "items"):as(function(items)
					return Cassiopea.table.map(items, function(item)
						return Widget.MenuButton({
							class_name = "systray-item",
							tooltip_markup = bind(item, "tooltip_markup"),
							use_popover = false,
							menu_model = bind(item, "menu-model"),
							action_group = bind(item, "action-group"):as(function(ag)
								return { "dbusmenu", ag }
							end),
							Widget.Icon({
								gicon = bind(item, "gicon"),
							}),
						})
					end)
				end),
			}),
		}),
	})
end

return Systray
