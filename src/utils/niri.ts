import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import AstalApps from "gi://AstalApps"
import { Accessor } from "gnim"

const apps = new AstalApps.Apps()

type NiriWindow = {
  id: string
  app_id: string
  title: string
  workspace_id: number
  is_focused: boolean
  is_floating: boolean
  is_urgent: boolean
}

type NiriWorkspace = {
  id: number
  idx: number
  output: string //monitor
  is_urgent: boolean
  is_active: boolean
  is_focused: boolean
  active_window_id: number
}

export type Window = {
  id: string
  appId: string
  title: string
  workspaceId: number
  isFocused: boolean
  isUrgent: boolean
}

export type Workspace = {
  id: number
  isFocused: boolean
  isActive: boolean
  monitor: string
  windows: Window[]
}

export function getAppIconName(appId: string): string {
  const appNameParts = appId.split(".")
  const app = apps.fuzzy_query(appNameParts.pop())[0]
  if (app) {
    return app.get_icon_name()
  }
  return "application-x-executable" // default icon
}

export const workspaces: Accessor<Workspace[]> = createPoll(
  [],
  1000,
  "bash -c 'niri msg -j workspaces'",
  function (result: string) {
    const parsedResult = JSON.parse(result)
    return parsedResult.map((ws: NiriWorkspace) => ({
      id: ws.id,
      isFocused: ws.is_focused,
      isActive: ws.is_active,
      monitor: ws.output,
      windows: [],
    }))
  },
)

export const windows: Accessor<Window[]> = createPoll(
  [],
  1000,
  "bash -c 'niri msg -j windows'",
  function (result: string) {
    const allWindows = JSON.parse(result)
    return allWindows.map((window: NiriWindow) => ({
      id: window.id,
      appId: window.app_id,
      title: window.title,
      workspaceId: window.workspace_id,
      isFocused: window.is_focused,
      isUrgent: window.is_urgent,
    }))
  },
)

export function deepCopy(obj: any): any {
  return Array.isArray(obj)
    ? obj.map(deepCopy)
    : obj !== null && typeof obj === "object"
      ? Object.fromEntries(
          Object.entries(obj).map(([k, v]) => [k, deepCopy(v)]),
        )
      : obj
}

export function sortById(a: Workspace, b: Workspace): number {
  return a.id - b.id
}

export function filterEmptyWorkspacesAndWorkspaceInOtherMonitors(
  ws: Workspace,
  currentMonitor: string | null,
): boolean {
  return ws.windows.length > 0 && ws.monitor === currentMonitor
}

export async function focusWindow(windowId: string): Promise<void> {
  try {
    const out = await execAsync([
      "bash",
      "-c",
      `niri msg action focus-window --id ${windowId}`,
    ])
    console.log("Focus window output:", out)
  } catch (error) {
    console.error(error)
  }
}
