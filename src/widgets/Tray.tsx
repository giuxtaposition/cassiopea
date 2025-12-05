import Gtk from "gi://Gtk?version=4.0"
import AstalTray from "gi://AstalTray"
import { For, createBinding, createState } from "ags"

const IconNameMapping: Record<string, string> = {
  "blueman-tray": "bluetooth-symbolic",
}

export function Tray() {
  const tray = AstalTray.get_default()
  const [visible, setVisible] = createState(false)
  const items = createBinding(tray, "items")

  const icon = (visible: boolean) => {
    if (visible) return "chevron-right-symbolic"
    else return "chevron-left-symbolic"
  }

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup)
    })
  }

  return (
    <box spacing={2}>
      <button onClicked={() => setVisible((v) => !v)}>
        <image iconName={visible((v) => icon(v))} pixelSize={20} />
      </button>
      <revealer
        revealChild={visible}
        transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
        transitionDuration={200}
      >
        <box spacing={2}>
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
      </revealer>
    </box>
  )
}
