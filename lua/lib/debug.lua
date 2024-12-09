---@class cassiopea.lib.debug
local M = {}

---@param table table
---@return string
local function dump(table)
	if type(table) == "table" then
		local s = "{ "
		for k, v in pairs(table) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(table)
	end
end

---@param table table
M.print_table = function(table)
	print(dump(table))
end

return M
