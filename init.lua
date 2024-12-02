local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.widgets.bar")
local Launcher = require("lua.widgets.launcher")
local src = require("lua.lib.path").src

local scss = src("scss/style.scss")
local css = "/tmp/style.css"

astal.exec("sass " .. scss .. " " .. css)

App:start({
	instance_name = "lua",
	css = css,
	request_handler = function(msg, res)
		print(msg)
		res("ok")
	end,
	main = function()
		for _, mon in pairs(App.monitors) do
			Bar(mon)
		end
		Launcher()
	end,
})
