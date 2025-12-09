import { Accessor, createComputed, For } from "gnim"
import {
  deepCopy,
  filterEmptyWorkspacesAndWorkspaceInOtherMonitors,
  focusWindow,
  getAppIconName,
  sortById,
  windows,
  Workspace,
  workspaces,
} from "../utils/niri"
import { Gdk } from "ags/gtk4"

export function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const workspacesData: Accessor<Workspace[]> = createComputed(() => {
    const workspacesValues = deepCopy(workspaces())
    const windowsValues = windows()

    for (const w of windowsValues) {
      const workspace = workspacesValues.find(
        (ws: Workspace) => ws.id === w.workspaceId,
      )
      if (workspace) {
        workspace.windows.push(w)
      }
    }

    return workspacesValues
      .sort(sortById)
      .filter((ws: Workspace) =>
        filterEmptyWorkspacesAndWorkspaceInOtherMonitors(
          ws,
          gdkmonitor.get_connector(),
        ),
      )
  })

  return (
    <box class="workspaces" spacing={8}>
      <For each={workspacesData}>
        {(ws) => (
          <box spacing={2}>
            <label label={`${ws.id}`} />
            <box spacing={2}>
              {ws.windows.map((window) => (
                <button
                  class={
                    "app-button" +
                    (window.isFocused ? " focused" : "") +
                    (window.isUrgent ? " urgent" : "")
                  }
                  onClicked={async () => await focusWindow(window.id)}
                >
                  <image
                    iconName={getAppIconName(window.appId)}
                    class={"app-icon"}
                  />
                </button>
              ))}
            </box>
          </box>
        )}
      </For>
    </box>
  )
}
