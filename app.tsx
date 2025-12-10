import app from "ags/gtk4/app"
import style from "./src/scss/style.scss"
import Bar from "./src/widgets/Bar"
import { createBinding, For, This } from "ags"
import Applauncher from "./src/widgets/Applauncher"
import NotificationPopups from "./src/widgets/NotificationPopups"
import { toggleWindow, WindowName } from "./src/utils/window"

app.start({
  instanceName: "cassiopea",
  css: style,
  icons: `${SRC}/icons`,
  requestHandler(argv: string[], response: (response: string) => void) {
    const [cmd, arg, ...rest] = argv
    if (cmd == "toggle") {
      toggleWindow(arg as WindowName)
      return response(arg)
    }
    response("unknown command")
  },
  main() {
    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
            <Applauncher gdkmonitor={monitor} />
            <NotificationPopups gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
