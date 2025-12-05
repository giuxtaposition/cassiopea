import { For, createState } from "ags"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import AstalApps from "gi://AstalApps"
import Graphene from "gi://Graphene"
import { WindowName } from "../utils/window"

const windowName: WindowName = "applauncher"

export default function Applauncher({
  gdkmonitor,
}: {
  gdkmonitor: Gdk.Monitor
}) {
  let contentbox: Gtk.Box
  let searchentry: Gtk.Entry
  let win: Astal.Window

  const apps = new AstalApps.Apps()
  const [list, setList] = createState(new Array<AstalApps.Application>())

  function search(text: string) {
    setList(apps.fuzzy_query(text).slice(0, 8))
  }

  function launch(app?: AstalApps.Application) {
    if (app) {
      win.hide()
      app.launch()
    }
  }

  // close on ESC
  // handle alt + number key
  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false
      return
    }

    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return launch(list.peek()[i - 1])
        }
      }
    }
  }

  // close on clickaway
  function onClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win)
    const position = new Graphene.Point({ x, y })

    if (!rect.contains_point(position)) {
      win.visible = false
      return true
    }
  }

  return (
    <window
      $={(ref) => (win = ref)}
      name={windowName}
      class={windowName}
      gdkmonitor={gdkmonitor}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      onNotifyVisible={({ visible }) => {
        if (visible) {
          searchentry.grab_focus()
          search("")
        } else searchentry.set_text("")
      }}
    >
      <Gtk.EventControllerKey onKeyPressed={onKey} />
      <Gtk.GestureClick onPressed={onClick} />
      <box
        $={(ref) => (contentbox = ref)}
        name="launcher-content"
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
        orientation={Gtk.Orientation.VERTICAL}
      >
        <entry
          class="entry"
          $={(ref) => (searchentry = ref)}
          onNotifyText={({ text }) => search(text)}
          placeholderText="Search..."
        />
        <Gtk.Separator visible={list((l) => l.length > 0)} />
        <box orientation={Gtk.Orientation.VERTICAL}>
          <For each={list}>
            {(app) => (
              <button onClicked={() => launch(app)}>
                <box class="applauncher-item">
                  <image iconName={app.iconName} pixel_size={24} />
                  <label
                    class="applauncher-item-label"
                    label={app.name}
                    maxWidthChars={40}
                    wrap
                  />
                </box>
              </button>
            )}
          </For>
        </box>
      </box>
    </window>
  )
}
