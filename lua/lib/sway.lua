local astal = require("astal")
local cjson = require("cjson")
local Variable = require("astal.variable")

local GLib = require("lgi").require("GLib")

local KEYBOARD_IDENTIFIER = GLib.getenv("KEYBOARD_IDENTIFIER")

---@class cassiopea.lib.sway
local M = {}

M.active_workspaces = Variable(nil):poll(1000, 'bash -c "swaymsg -t get_workspaces"', function(result)
	local decode = cjson.decode(result)
	local res = Cassiopea.table.map(decode, function(item)
		return { id = item.name, focused = item.focused }
	end)
	return res
end)

M.toggle_keyboard = function()
	astal.exec('bash -c "swaymsg input ' .. KEYBOARD_IDENTIFIER .. ' events toggle enabled disabled"')
end

M.keyboard = Variable({ layout = "en", enabled = true }):poll(1000, 'bash -c "swaymsg -t get_inputs"', function(result)
	local decode = cjson.decode(result)
	local keyboard = Cassiopea.table.find(decode, function(item)
		return item.identifier == KEYBOARD_IDENTIFIER
	end)

	if keyboard == nil then
		return { layout = "en", enabled = true }
	end

	local layout = string.find(keyboard.xkb_active_layout_name, "Eng") and "en" or "it"
	local enabled = keyboard.libinput.send_events == "enabled"

	return { layout = layout, enabled = enabled }
end)

return M
