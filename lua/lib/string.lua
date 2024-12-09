---@class cassiopea.lib.string
local M = {}

---@param input string
---@param delimiter string
---@return string[]
M.split = function(input, delimiter)
	local result = {}
	for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

return M
