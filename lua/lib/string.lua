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

---@param str string
---@param max_length number
---@param suffix? string
M.truncate = function(str, max_length, suffix)
	if max_length <= 0 then
		return ""
	end

	if #str <= max_length then
		return str
	end

	suffix = suffix or "..."
	return string.sub(str, 1, max_length) .. suffix
end

return M
