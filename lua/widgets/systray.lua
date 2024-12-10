local Tray = require("lgi").require("AstalTray")
local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local bind = astal.bind
local App = require("astal.gtk3.app")
local Gdk = astal.require("Gdk", "3.0")
local Astal = astal.require("Astal", "3.0")
local tray = Tray.get_default()

return function()
	return Widget.Window({
		name = Cassiopea.windows.window_name.systray,
		visible = false,
		anchor = Astal.WindowAnchor.TOP + Astal.WindowAnchor.RIGHT,
		exclusivity = Astal.Exclusivity.EXCLUSIVE,
		keymode = Astal.Keymode.ON_DEMAND,
		application = App,
		setup = function(self)
			App:add_window(self)
		end,
		on_key_press_event = function(self, event)
			if event:get_keyval() == Gdk.KEY_Escape then
				self:hide()
			end
		end,
		Widget.Box({
			class_name = "systray",
			-- spacing = 16,
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
	})
end
