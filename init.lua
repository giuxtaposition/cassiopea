_G.Cassiopea = require("lua.lib.init")
local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.widgets.bar")
local Launcher = require("lua.widgets.launcher")
local QuickSettings = require("lua.widgets.quick_settings")
local PowerMenu = require("lua.widgets.power_menu")
local Notifications = require("lua.widgets.notifications")

local scss = Cassiopea.path.cwd("scss/style.scss")
local css = "/tmp/style.css"

astal.exec("sass " .. scss .. " " .. css)

App:start({
	instance_name = "cassiopea",
	css = css,
	main = function()
		for _, mon in pairs(App.monitors) do
			Bar(mon)
			Notifications(mon)
		end
		Launcher()
		QuickSettings()
		PowerMenu()
	end,
	---@param request string
	---@param res fun(response: any): nil
	request_handler = function(request, res)
		if string.find(request, "toggle") then
			local window_name = request:match("toggle%s+(%w+)")
			Cassiopea.windows.toggle(window_name)
		end

		res("unknown command")
	end,
	---@param message fun(msg: string): string
	---@param args string
	client = function(message, args)
		if args == nil then
			return
		end

		local res = message(args)
		if res ~= nil then
			print(res)
		end
	end,
})
