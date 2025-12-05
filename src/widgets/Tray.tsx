import Gtk from "gi://Gtk?version=4.0"
import AstalTray from "gi://AstalTray"
import { For, createBinding } from "ags"

const IconNameMapping: Record<string, string> = {
  "blueman-tray": "bluetooth-symbolic",
}

export function Tray() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup)
    })
  }

  return (
    <box>
      <For each={items}>
        {(item) => {
          const iconName = createBinding(item, "iconName")
          const mappedIconName = IconNameMapping[iconName.peek()]
          return (
            <menubutton $={(self) => init(self, item)}>
              {mappedIconName ? (
                <image
                  iconName={iconName((icon) => IconNameMapping[icon])}
                  gicon={item.get_gicon()}
                  pixelSize={16}
                />
              ) : (
                <image gicon={item.get_gicon()} pixelSize={16} />
              )}
            </menubutton>
          )
        }}
      </For>
    </box>
  )
}
