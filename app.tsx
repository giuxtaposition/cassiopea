import app from "ags/gtk4/app"
import style from "./src/scss/style.scss"
import Bar from "./src/widgets/Bar"
import { createBinding, For, This } from "ags"
import Applauncher from "./src/widgets/Applauncher"
import NotificationPopups from "./src/widgets/NotificationPopups"

app.start({
  css: style,
  icons: `${SRC}/icons`,
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
