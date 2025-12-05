import app from "ags/gtk4/app"
import style from "./src/scss/style.scss"
import Bar from "./src/widgets/Bar"
import { createBinding, For, This } from "ags"

app.start({
  css: style,
  main() {
    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
