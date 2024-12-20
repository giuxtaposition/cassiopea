local Widget = require("astal.gtk3.widget")
local Tray = require("lgi").require("AstalTray")
local tray = Tray.get_default()
local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local App = require("astal.gtk3.app")
local Gdk = astal.require("Gdk", "3.0")

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
						if item.icon_theme_path ~= nil then
							App:add_icons(item.icon_theme_path)
						end

						local menu = item:create_menu()

						return Widget.Button({
							class_name = "systray-item",
							tooltip_markup = bind(item, "tooltip_markup"),
							on_destroy = function()
								if menu ~= nil then
									menu:destroy()
								end
							end,
							on_click_release = function(self)
								if menu ~= nil then
									menu:popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, nil)
								end
							end,
							Widget.Icon({
								g_icon = bind(item, "gicon"),
							}),
						})
					end)
				end),
			}),
		}),
	})
end

return Systray
