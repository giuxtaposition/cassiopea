local Widget = require("astal.gtk3.widget")

---@param monitor_name string
local function WorkspacesComponent(monitor_name)
	return Widget.Box({
		class_name = "workspaces",
		Cassiopea.niri.workspaces(function(workspaces)
			if workspaces == nil then
				return {}
			end

			local workspaces_for_monitor = Cassiopea.table.filter(workspaces, function(workspace)
				return workspace.monitor == monitor_name
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

---@param monitor_name string
local function Workspaces(monitor_name)
	return Widget.EventBox({
		class_name = "workspaces panel-button",
		Widget.Box({
			Widget.EventBox({
				class_name = "eventbox",
				WorkspacesComponent(monitor_name),
			}),
		}),
	})
end

return Workspaces
