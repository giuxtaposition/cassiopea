---@class cassiopea.lib
---@field debug cassiopea.lib.debug
---@field path cassiopea.lib.path
---@field string cassiopea.lib.string
---@field table cassiopea.lib.table
---@field windows cassiopea.lib.windows
---@field sharing cassiopea.lib.sharing
local M = {
	debug = require("lua.lib.debug"),
	path = require("lua.lib.path"),
	string = require("lua.lib.string"),
	table = require("lua.lib.table"),
	windows = require("lua.lib.windows"),
	sharing = require("lua.lib.sharing"),
}

return M
