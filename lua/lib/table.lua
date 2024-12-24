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
function M.find_in_arr(arr, condition)
	for _, value in ipairs(arr) do
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

---@generic T
---@param arr T[]
---@param first integer
---@param last? integer
function M.slice(arr, first, last)
	local sliced = {}

	for i = first, last or #arr, 1 do
		sliced[#sliced + 1] = arr[i]
	end

	return sliced
end
---@param tbl table<any, any>
---@param condition fun(element: any): boolean
---@return any, any
function M.find_in_tbl(tbl, condition)
	for key, element in pairs(tbl) do
		if condition(element) then
			return key, element
		end
	end
	return nil, nil
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
