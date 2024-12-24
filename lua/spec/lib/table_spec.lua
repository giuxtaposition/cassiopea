local table = require("lib.table")

describe("Table lib", function()
	local arr = {
		{
			value = "hello",
			key = 1,
		},
		{
			value = "world",
			key = 2,
		},
	}

	describe("map", function()
		it("should creates a new array from calling a function for every array element", function()
			assert.are_same(
				{
					"hello",
					"world",
				},
				table.map(arr, function(v)
					return v.value
				end)
			)
		end)
	end)

	describe("find_in_arr", function()
		it("should return the first element that satisfies the condition", function()
			assert.are_same(
				{
					value = "world",
					key = 2,
				},
				table.find_in_arr(arr, function(v)
					return v.value == "world"
				end)
			)
		end)

		it("should return nil if no element satisfies the condition", function()
			assert.are_equal(
				nil,
				table.find_in_arr(arr, function(v)
					return v.value == "not found"
				end)
			)
		end)
	end)

	describe("filter", function()
		it("should return a new array with elements that satisfy the condition", function()
			assert.are_same(
				{
					{
						value = "world",
						key = 2,
					},
				},
				table.filter(arr, function(v)
					return v.value == "world"
				end)
			)
		end)
		it("should return an empty array if no element satisfies the condition", function()
			assert.are_same(
				{},
				table.filter(arr, function(v)
					return v.value == "not found"
				end)
			)
		end)
	end)

	describe("slice", function()
		it("should return a new array with elements from the first to the last index", function()
			assert.are_same({
				{
					value = "world",
					key = 2,
				},
			}, table.slice(arr, 2))
		end)
	end)

	describe("find_in_tbl", function()
		local tbl = {
			id1 = {
				a = "hello",
				b = "world",
			},
			id2 = {
				a = "lua",
				b = "table",
			},
		}

		it("should return the element that matches condition", function()
			local key, value = table.find_in_tbl(tbl, function(element)
				return element.a == "lua"
			end)

			assert.are_equal("id2", key)
			assert.are_same({
				a = "lua",
				b = "table",
			}, value)
		end)
	end)
end)
