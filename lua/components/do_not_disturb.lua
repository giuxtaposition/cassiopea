local astal = require("astal")
local bind = astal.bind

local Notifd = require("lgi").require("AstalNotifd")

local Widget = require("astal.gtk3.widget")

local M = {}
local notifd = Notifd.get_default()

M.DoNotDisturbIcon = function()
	return Widget.Label({
		class_name = "indicator-icon",
		tooltip_text = bind(notifd, "dont-disturb"):as(tostring),
		label = bind(notifd, "dont-disturb"):as(function(dnd)
			return dnd and Cassiopea.icons.do_not_disturb.enabled or Cassiopea.icons.do_not_disturb.disabled
		end),
	})
end

M.ToggleDoNotDisturb = function()
	return Widget.Button({
		class_name = bind(notifd, "dont-disturb"):as(function(enabled)
			local class_name = "toggle-button "
			return class_name .. (enabled and "active" or "")
		end),
		on_clicked = function()
			if notifd["dont-disturb"] then
				notifd["dont-disturb"] = false
			else
				notifd["dont-disturb"] = true
			end
		end,
		Widget.Box({
			M.DoNotDisturbIcon(),
			Widget.Box({
				class_name = "text",
				Widget.Label({
					class_name = "title",
					label = bind(notifd, "dont-disturb"):as(function(dnd)
						return dnd and "Silent" or "Noisy"
					end),
				}),
			}),
		}),
	})
end

return M
