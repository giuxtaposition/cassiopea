import app from "ags/gtk4/app"

export type WindowName = "bar" | "applauncher" | "notification-popups"

export function toggleWindow(windowName: WindowName) {
  const window = app.get_window(windowName)
  if (window) {
    window.visible = !window.visible
  }
}
