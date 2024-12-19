local astal = require("astal")
local Variable = require("astal.variable")

---@class cassiopea.lib.niri
local M = {}

M.mapping_keyboard_layout = {
	["English (US)"] = "en",
	["Italian"] = "it",
}

M.keyboard_layout = Variable("en"):poll(1000, 'bash -c "niri msg -j keyboard-layouts"', function(result)
	local decoded = Cassiopea.json.decode(result)
	local active_layout = decoded.names[decoded.current_idx + 1]

	return M.mapping_keyboard_layout[active_layout]
end)

M.switch_keyboard_layout = function()
	astal.exec('bash -c "niri msg action switch-layout next"')
end

M.workspaces = Variable({
	[1] = { ["is_active"] = true, ["is_focused"] = true },
}):poll(1000, 'bash -c "niri msg -j workspaces"', function(result)
	local decode = Cassiopea.json.decode(result)
	local workspaces = {}

	for _, item in ipairs(decode) do
		workspaces[item.idx] = { is_active = (item.active_window_id ~= nil), is_focused = item.is_focused }
	end

	return workspaces
end)

return M
