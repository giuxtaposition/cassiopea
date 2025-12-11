import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import { DateTime } from "./DateTime"
import { WindowName } from "../utils/window"
import { onCleanup } from "ags"
import { SearchApps } from "./SearchApps"
import { Tray } from "./Tray"
import { BatteryIndicator } from "./BatteryIndicator"
import { WifiIndicator } from "./WifiIndicator"
import { AudioOutputIndicator } from "./AudioOutputIndicator"
import { Workspaces } from "./Workspaces"
import { ScreenSharingIndicator } from "./ScreenSharingIndicator"

const windowName: WindowName = "bar"

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  onCleanup(() => {
    // Root components (windows) are not automatically destroyed.
    // When the monitor is disconnected from the system, this callback
    // is run from the parent <For> which allows us to destroy the window
    win.destroy()
  })

  return (
    <window
      $={(self) => (win = self)}
      visible
      name={windowName}
      class={windowName}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox>
        <box $type="start" spacing={4}>
          <SearchApps />
          <Workspaces gdkmonitor={gdkmonitor} />
        </box>
        <box $type="center">
          <DateTime format="%H:%M - %A %d" />
        </box>
        <box $type="end" spacing={4}>
          <Tray />
          <ScreenSharingIndicator />
          <WifiIndicator />
          <AudioOutputIndicator />
          <BatteryIndicator />
        </box>
      </centerbox>
    </window>
  )
}
