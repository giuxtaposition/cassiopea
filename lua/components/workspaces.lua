local Widget = require("astal.gtk3.widget")

local function WorkspacesComponent()
	return Widget.Box({
		class_name = "workspaces",
		Cassiopea.niri.workspaces(function(workspaces)
			return Cassiopea.table.map(workspaces, function(workspace)
				return Widget.Button({
					class_name = (function()
						return string.format(
							"workspace %s %s",
							workspace.is_active and "active" or "inactive",
							workspace.is_focused and "focused" or ""
						)
					end)(),
				})
			end)
		end),
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
