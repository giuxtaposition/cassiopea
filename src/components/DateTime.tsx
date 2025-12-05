import { createPoll } from "ags/time"
import GLib from "gi://GLib"
import Gtk from "gi://Gtk?version=4.0"

export function DateTime(props: { format: string }) {
  const time = createPoll("", 1000, () => {
    return GLib.DateTime.new_now_local().format(props.format)!
  })

  return (
    <menubutton class="date-time">
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}
