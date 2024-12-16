local Variable = require("astal").Variable
local Gtk = require("astal.gtk3").Gtk
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

---@generic T
---@param arr T[]
---@param predicate fun(T, integer): boolean
---@return T[]
function M.filter(arr, predicate)
	local result = {}
	for i, value in ipairs(arr) do
		if predicate(value, i) then
			table.insert(result, value)
		end
	end
	return result
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

function M.varmap(initial)
	local map = initial
	local var = Variable()

	local function notify()
		local arr = {}
		for _, value in pairs(map) do
			table.insert(arr, value)
		end
		var:set(arr)
	end

	local function delete(key)
		if Gtk.Widget:is_type_of(map[key]) then
			map[key]:destroy()
		end

		map[key] = nil
	end

	notify()

	return setmetatable({
		set = function(key, value)
			delete(key)
			map[key] = value
			notify()
		end,
		delete = function(key)
			delete(key)
			notify()
		end,
		get = function()
			return var:get()
		end,
		subscribe = function(callback)
			return var:subscribe(callback)
		end,
	}, {
		__call = function()
			return var()
		end,
	})
end

return M
