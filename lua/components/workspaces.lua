local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local bind = astal.bind

-- label = my_var(function(value)
--       return string.format("transformed %s", value)
--   end)

local value = Cassiopea.sway.workspaces(function(value)
	Cassiopea.debug.print_table(value)
end)
-- Cassiopea.debug.print_table(value)

local function Workspaces()
	return Widget.Box({
		class_name = "workspaces",
		Cassiopea.sway.workspaces(function(wss)
			print("workspaces")
			Cassiopea.debug.print_table(wss)

			return Cassiopea.table.map(wss, function(ws)
				print("workspace")
				Cassiopea.debug.print_table(ws)

				return Widget.Button({
					class_name = function()
						local active = ws.active and "active" or ""
						local focused = ws.focused and "focused" or ""
						return "workspace" .. " " .. active .. " " .. focused
					end,
					on_clicked = function()
						-- ws:focus()
					end,
					-- label = bind(ws, "id"):as(function(v)
					-- 	return type(v) == "number" and string.format("%.0f", v) or v
					-- end),
				})
			end)
		end),
	})
end

return Workspaces
