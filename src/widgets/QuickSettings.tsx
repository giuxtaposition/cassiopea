import Gtk from "gi://Gtk?version=4.0"
import { IconButton } from "../components/IconButton"
import { icons } from "../lib/icons"
import { rebootSystem, shutdownSystem } from "../utils/powermenu"
import { NightLightButton } from "./NightLightButton"
import { DoNotDisturbButton } from "./DoNotDisturbButton"

export function QuickSettings() {
  return (
    <IconButton
      iconName={icons.settings}
      popoverContent={
        <box
          class="quick-settings-popover"
          spacing={16}
          orientation={Gtk.Orientation.VERTICAL}
        >
          <centerbox>
            <box $type="start" spacing={4}></box>
            <box $type="center" spacing={4}></box>
            <box $type="end" spacing={4}>
              <IconButton
                iconName={icons.powermenu.reboot}
                onClick={rebootSystem}
                size={15}
              />
              <IconButton
                iconName={icons.powermenu.shutdown}
                onClick={shutdownSystem}
                size={15}
              />
            </box>
          </centerbox>
          <box spacing={8}>
            <NightLightButton />
            <DoNotDisturbButton />
          </box>
        </box>
      }
    />
  )
}
