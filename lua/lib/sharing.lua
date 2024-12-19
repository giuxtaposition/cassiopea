local Variable = require("astal.variable")
local split = require("lua.lib.string").split

---@class cassiopea.lib.sharing
local M = {}

M.screen_sharing = Variable(false):poll(1000, 'bash -c "pactl -f json list clients"', function(result)
	local clients = Cassiopea.json.decode(result)

	local screen_sharing = false
	for _, client in ipairs(clients) do
		if client.properties and client.properties["pipewire.access"] == "portal" then
			screen_sharing = true
			break
		end
	end

	return screen_sharing
end)

M.mic_recording = Variable(false):poll(1000, 'bash -c "pactl -f json list source-outputs"', function(result)
	local sources = Cassiopea.json.decode(result)
	return #sources > 0
end)

M.webcam_recording = Variable(false):poll(
	1000,
	'bash -c "lsof /dev/video0 | awk \'{print; found=1} END {if (!found) print \\"No output\\"}\'"',
	function(result)
		local is_recording = false
		if result == "No output" then
			return is_recording
		end

		local lines = split(result, "\n")
		local processes = {}
		for i = 2, #lines do
			local parts = split(lines[i], "%s+")
			if #parts > 1 then
				table.insert(processes, parts[1])
			end
		end

		for _, process in ipairs(processes) do
			if process ~= "wireplumb" and process ~= "pipewire" then
				is_recording = true
				break
			end
		end

		return is_recording
	end
)

return M
