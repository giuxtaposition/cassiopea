local Widget = require("astal.gtk3.widget")

local function WorkspacesComponent()
	return Widget.Box({
		class_name = "workspaces",
		(function()
			local children = {}
			for i = 1, 10 do
				table.insert(
					children,
					Widget.Button({
						class_name = Cassiopea.sway.active_workspaces(function(actives)
							if actives == nil then
								return "workspace empty"
							end

							local found = Cassiopea.table.find(actives, function(workspace)
								return tostring(workspace.id) == tostring(i)
							end)

							local class_name = "workspace "
							if found == nil then
								class_name = class_name .. "empty"
							else
								class_name = class_name .. (found.focused and "active" or "occupied")
							end

							return class_name
						end),
					})
				)
			end
			return children
		end)(),
	})
end

local function Workspaces()
	return Widget.EventBox({
		class_name = "workspaces panel-button",
		Widget.Box({
			Widget.EventBox({
				class_name = "eventbox",
				WorkspacesComponent(),
			}),
		}),
	})
end

return Workspaces
