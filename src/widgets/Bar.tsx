import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import { DateTime } from "../components/DateTime"
import { WindowName } from "../utils/window"

const windowName: WindowName = "bar"

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name={windowName}
      class={windowName}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox>
        <box $type="center">
          <DateTime format="%H:%M - %A %d" />
        </box>
      </centerbox>
    </window>
  )
}
