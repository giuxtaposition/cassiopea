local Widget = require("astal.gtk3.widget")

---@param monitor_model string
local function WorkspacesComponent(monitor_model)
	return Widget.Box({
		class_name = "workspaces",
		Cassiopea.niri.workspaces(function(workspaces)
			local workspaces_for_monitor = Cassiopea.table.filter(workspaces, function(workspace)
				return workspace.monitor == Cassiopea.niri.get_monitor_name(monitor_model)
			end)
			return Cassiopea.table.map(workspaces_for_monitor, function(workspace)
				return Widget.Button({
					on_click = function()
						Cassiopea.niri.focus_workspace(workspace.index)
					end,
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

---@param monitor_model string
local function Workspaces(monitor_model)
	return Widget.EventBox({
		class_name = "workspaces panel-button",
		Widget.Box({
			Widget.EventBox({
				class_name = "eventbox",
				WorkspacesComponent(monitor_model),
			}),
		}),
	})
end

return Workspaces
