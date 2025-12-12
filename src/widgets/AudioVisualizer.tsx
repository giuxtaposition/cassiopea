import { Gtk } from "ags/gtk4"
import Cava from "gi://AstalCava"
import { createBinding, With } from "gnim"

export function AudioVisualizer() {
  const cava = Cava.get_default()!
  const bars = createBinding(cava, "values")

  return (
    <With value={bars}>
      {(values) =>
        values.length > 0 && (
          <drawingarea
            widthRequest={150}
            class={"audio-visualizer"}
            $={(self) =>
              self.set_draw_func((area, cr, width, height) => {
                const h = self.get_allocated_height()
                const w = self.get_allocated_width()
                const bars = cava.get_bars()
                const values = cava.get_values()

                Gtk.render_background(self.get_style_context(), cr, 0, 0, w, h)
                const fg = self.get_style_context().get_color()
                cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha)

                const barWidth = w / bars
                const padding = 2

                for (let i = 0; i < bars; i++) {
                  const value = values[i] ?? 0
                  const barHeight = h * value
                  const x = i * barWidth + padding / 2
                  const y = h - barHeight

                  cr.rectangle(x, y, barWidth - padding, barHeight)
                  cr.fill()
                }
              })
            }
          />
        )
      }
    </With>
  )
}
