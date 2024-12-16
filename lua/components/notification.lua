local Widget = require("astal.gtk3").Widget
local Gtk = require("astal.gtk3").Gtk
local astal = require("astal")
local GLib = astal.require("GLib")
local Astal = require("astal.gtk3").Astal

local function file_exists(path)
	return GLib.file_test(path, "EXISTS")
end

local function is_icon(icon)
	return Astal.Icon.lookup_icon(icon) ~= nil
end

---@param time number
---@param format? string
local function time(time, format)
	format = format or "%H:%M"
	return GLib.DateTime.new_from_unix_local(time):format(format)
end

---@param props { setup?: function, on_hover_lost?: function, notification: any }
return function(props)
	local n = props.notification

	local header = Widget.Box({
		class_name = "header",
		(n.app_icon or n.desktop_entry) and Widget.Icon({
			class_name = "app-icon",
			icon = n.app_icon or n.desktop_entry,
		}) or nil,
		Widget.Label({
			class_name = "app-name",
			halign = "START",
			ellipsize = "END",
			label = n.app_name or "Unknown",
		}),
		Widget.Label({
			class_name = "time",
			hexpand = true,
			halign = "END",
			label = time(n.time),
		}),
		Widget.Button({
			on_clicked = function()
				n:dismiss()
			end,
			Widget.Icon({ icon = "window-close-symbolic" }),
		}),
	})

	local content = Widget.Box({
		class_name = "content",
		(n.image and file_exists(n.image)) and Widget.Box({
			valign = "START",
			class_name = "image",
			css = string.format("background-image: url('%s')", n.image),
		}) or nil,
		n.image and is_icon(n.image) and Widget.Box({
			valign = "START",
			class_name = "icon-image",
			Widget.Icon({
				icon = n.image,
				hexpand = true,
				vexpand = true,
				halign = "CENTER",
				valign = "CENTER",
			}),
		}) or nil,
		Widget.Box({
			vertical = true,
			Widget.Label({
				class_name = "summary",
				halign = "START",
				xalign = 0,
				ellipsize = "END",
				label = n.summary,
			}),
			Widget.Label({
				class_name = "body",
				wrap = true,
				use_markup = true,
				halign = "START",
				xalign = 0,
				justify = "FILL",
				label = n.body,
			}),
		}),
	})

	return Widget.EventBox({
		class_name = string.format("notification %s", string.lower(n.urgency)),
		setup = props.setup,
		on_hover_lost = props.on_hover_lost,
		Widget.Box({
			vertical = true,
			header,
			Gtk.Separator({ visible = true }),
			content,
			Widget.Box({
				(#n.actions > 0) and Widget.Box({
					Cassiopea.table.map(n.actions, function(action)
						local label, id = action.label, action.id

						return Widget.Button({
							hexpand = true,
							on_clicked = function()
								return n:invoke(id)
							end,
							Widget.Label({
								label = label,
								halign = "CENTER",
								hexpand = true,
							}),
						})
					end),
				}) or nil,
			}),
		}),
	})
end
