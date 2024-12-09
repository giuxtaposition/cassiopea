local astal = require("astal")
local bind = astal.bind
local App = require("astal.gtk3.app")
local Widget = require("astal.gtk3.widget")
local Gdk = astal.require("Gdk", "3.0")
local Variable = require("astal").Variable
local Apps = require("lgi").require("AstalApps")
local Astal = astal.require("Astal", "3.0")

local MAX_ITEMS = 8

local function hide()
	Cassiopea.windows.hide(Cassiopea.windows.window_name.launcher)
end

return function()
	local apps = Apps.Apps()
	local text = Variable("")

	local list = text(function(value)
		return Cassiopea.table.slice(apps:fuzzy_query(value), 0, MAX_ITEMS)
	end)

	local on_enter = function()
		apps.fuzzy_query(text:get())[0].launch()
		hide()
	end

	local SearchBar = Widget.Box({
		hexpand = true,
		class_name = "search-bar",
		Widget.Icon({
			icon = "system-search",
		}),
		Widget.Entry({
			hexpand = true,
			placeholder_text = "Search",
			text = text(),
			on_changed = function(self)
				text:set(self.text)
			end,
			on_activate = function()
				on_enter()
			end,
		}),
	})

	local AppButton = function(item)
		return Widget.Button({
			class_name = "item",
			on_click_release = function()
				hide()
				item:launch()
			end,
			Widget.Box({
				Widget.Icon({
					icon = item.icon_name,
				}),
				Widget.Box({
					valign = "CENTER",
					vertical = true,
					Widget.Label({
						class_name = "name",
						xalign = 0,
						label = item.name,
					}),
				}),
			}),
		})
	end

	return Widget.Window({
		name = Cassiopea.windows.window_name.launcher,
		visible = false,
		anchor = Astal.WindowAnchor.TOP + Astal.WindowAnchor.LEFT,
		exclusivity = Astal.Exclusivity.EXCLUSIVE,
		keymode = Astal.Keymode.ON_DEMAND,
		application = App,
		on_show = function()
			text:set("")
		end,
		setup = function(self)
			App:add_window(self)
		end,
		on_key_press_event = function(self, event)
			if event:get_keyval() == Gdk.KEY_Escape then
				self:hide()
			end
		end,
		Widget.Box({
			hexpand = false,
			vertical = true,
			Widget.EventBox({
				on_click = function()
					hide()
				end,
			}),
			Widget.Box({
				width_request = 500,
				vertical = true,
				class_name = "app_launcher",
				spacing = 4,
				SearchBar,
				Widget.Box({
					spacing = 6,
					vertical = true,
					bind(list, "items"):as(function(items)
						return Cassiopea.table.map(items, function(item)
							return AppButton(item)
						end)
					end),
				}),
			}),
			Widget.EventBox({
				expand = true,
				on_click = function()
					hide()
				end,
			}),
		}),
	})
end
