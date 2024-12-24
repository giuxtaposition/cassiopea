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
		for _, gdkmonitor in pairs(App.monitors) do
			Windows.bars[gdkmonitor] = Bar(gdkmonitor, Cassiopea.niri.get_monitor_name(gdkmonitor.model))
			Windows.notifications[gdkmonitor] = Notifications(gdkmonitor)
		end
		Launcher()
		QuickSettings()
		PowerMenu()

		App.on_monitor_added = function(_, mon)
			Windows.bars[mon] = Bar(mon, Cassiopea.niri.get_monitor_name(mon.model))
			Windows.notifications[mon] = Notifications(mon)
		end

		App.on_monitor_removed = function(_, mon)
			Windows.bars[mon].destroy()
			Windows.notifications[mon].destroy()
			Windows.bars[mon] = nil
			Windows.notifications[mon] = nil
		end
	end,
	---@param request string
	---@param res fun(response: any): nil
	request_handler = function(request, res)
		if string.find(request, "toggle") then
			local window_name = string.match(request, "%w+%s+(.*)")
			if window_name == nil then
				res("no window name provided")
			end
			if Cassiopea.windows.window_name[window_name] == nil then
				res("window not found")
			end

			Cassiopea.windows.toggle(Cassiopea.windows.window_name[window_name])
			res("toggled " .. window_name)
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
