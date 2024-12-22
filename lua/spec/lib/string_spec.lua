local string = require("lib.string")

describe("String lib", function()
	describe("split", function()
		it("should split a string to an array", function()
			assert.are_same({
				"hello",
				"world",
			}, string.split("hello world", " "))
		end)
	end)

	describe("truncate", function()
		it("should truncate a string to a certain length", function()
			assert.are_same("hello...", string.truncate("hello world", 5))
		end)

		it("should truncate a string to a certain length with a custom suffix", function()
			assert.are_same("hello!!!", string.truncate("hello world", 5, "!!!"))
		end)
	end)
end)
