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

---@generic T
---@param arr T[]
---@param condition fun(T): boolean
function M.find(arr, condition)
	for _, value in ipairs(arr) do
		-- Cassiopea.debug.print_table(value)
		-- print(condition(value))

		if condition(value) then
			return value
		end
	end
	return nil
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

---@param tbl table
---@param value any
function M.containsValue(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

return M
