import { Gtk } from "ags/gtk4"
import Cava from "gi://AstalCava"
import { createBinding, With } from "gnim"

export function AudioVisualizer() {
  const cava = Cava.get_default()!
  const canvasValues = createBinding(cava, "values")

  return (
    <With value={canvasValues}>
      {(values) =>
        values.some((v) => v !== 0) && (
          <drawingarea
            widthRequest={150}
            class={"audio-visualizer"}
            $={(self) =>
              self.set_draw_func((_area, cr, _width, _height) => {
                const h = self.get_allocated_height()
                const w = self.get_allocated_width()
                const bars = cava.get_bars()
                const values = cava.get_values()

                Gtk.render_background(self.get_style_context(), cr, 0, 0, w, h)
                const fg = self.get_style_context().get_color()
                cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha)

                const barWidth = w / bars
                const padding = 2

                const silent = values.every((v) => v < 0.001)

                if (silent) {
                  const y = h * 1
                  cr.setLineWidth(1)
                  cr.moveTo(0, y)
                  cr.lineTo(w, y)
                  cr.stroke()
                  return
                }

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
