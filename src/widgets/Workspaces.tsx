import { Accessor, createComputed, For, With } from "gnim"
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
import { Gdk, Gtk } from "ags/gtk4"
import { icons } from "../lib/icons"

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
            <centerbox orientation={Gtk.Orientation.VERTICAL}>
              <box
                class="workspace-label"
                $type="center"
                orientation={Gtk.Orientation.VERTICAL}
                spacing={2}
              >
                <revealer
                  revealChild={ws.isFocused}
                  transitionDuration={200}
                  transitionType={Gtk.RevealerTransitionType.SWING_DOWN}
                >
                  <image iconName={icons.dot} pixelSize={4} />
                </revealer>
                <label
                  label={`${ws.id}`}
                  class={ws.isFocused ? "focused" : ""}
                />
              </box>
            </centerbox>
            <centerbox orientation={Gtk.Orientation.VERTICAL}>
              <box spacing={2} $type="center">
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
            </centerbox>
          </box>
        )}
      </For>
    </box>
  )
}
