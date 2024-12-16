_G.Cassiopea = require("lua.lib.init")
local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.widgets.bar")
local Launcher = require("lua.widgets.launcher")
local Systray = require("lua.widgets.systray")
local QuickSettings = require("lua.widgets.quick_settings")
local PowerMenu = require("lua.widgets.power_menu")
local Notifications = require("lua.widgets.notifications")

local scss = Cassiopea.path.cwd("scss/style.scss")
local css = "/tmp/style.css"

astal.exec("sass " .. scss .. " " .. css)

App:start({
	instance_name = "cassiopea",
	css = css,
	request_handler = function(msg, res)
		print(msg)
		res("ok")
	end,
	main = function()
		for _, mon in pairs(App.monitors) do
			Bar(mon)
			Notifications(mon)
		end
		Launcher()
		Systray()
		QuickSettings()
		PowerMenu()
	end,
})
