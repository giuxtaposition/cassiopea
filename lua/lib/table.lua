---@class cassiopea.lib.table
local M = {}

---@generic T, R
---@param arr T[]
---@param func fun(T, integer): R
---@return R[]
function M.map(arr, func)
	local new_arr = {}
	for i, v in ipairs(arr) do
		new_arr[i] = func(v, i)
	end
	return new_arr
end

---@param tbl table
---@param first integer
---@param last? integer
function M.slice(tbl, first, last)
	local sliced = {}

	for i = first, last or #tbl, 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

return M
