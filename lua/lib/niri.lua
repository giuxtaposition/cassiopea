local astal = require("astal")
local Variable = require("astal.variable")

---@class cassiopea.lib.niri
local M = {}

M.mapping_keyboard_layout = {
	["English (US)"] = "en",
	["English (intl., with AltGr dead keys)"] = "en",
	["Italian"] = "it",
}

M.keyboard_layout = Variable("en"):poll(1000, 'bash -c "niri msg -j keyboard-layouts"', function(result)
	local decoded = Cassiopea.json.decode(result)
	local active_layout = decoded.names[decoded.current_idx + 1]

	if string.find(active_layout, "English") then
		return "en"
	else
		return "it"
	end
end)

M.switch_keyboard_layout = function()
	astal.exec('bash -c "niri msg action switch-layout next"')
end

M.workspaces = Variable(nil):poll(1000, 'bash -c "niri msg -j workspaces"', function(result)
	local decode = Cassiopea.json.decode(result)
	local workspaces = {}

	for _, item in ipairs(decode) do
		table.insert(workspaces, {
			monitor = item.output,
			index = item.idx,
			is_active = (item.active_window_id ~= nil),
			is_focused = item.is_focused,
		})
	end

	table.sort(workspaces, function(a, b)
		return a.index < b.index
	end)

	return workspaces
end)

M.get_monitor_name = function(monitor_model)
	local outputs = astal.exec("niri msg -j outputs")
	local decoded = Cassiopea.json.decode(outputs)
	local monitor = Cassiopea.table.find_in_tbl(decoded, function(monitor)
		return monitor.model == monitor_model
	end)
	return monitor
end

M.focus_workspace = function(idx)
	astal.exec(string.format('bash -c "niri msg action focus-workspace %d"', idx))
end

---@param app_id string
M.focus_window = function(app_id)
	astal.exec_async('bash -c "niri msg -j windows"', function(result, err)
		if result then
			local decoded = Cassiopea.json.decode(result)
			local window_id = Cassiopea.table.find_in_arr(decoded, function(window)
				return window.app_id == app_id
			end).id

			if window_id ~= nil then
				astal.exec_async(string.format("niri msg action focus-window --id %d", window_id))
			end
		else
			print(err)
		end
	end)
end

return M
