import { IconButton } from "../components/IconButton"
import { icons } from "../lib/icons"
import { rebootSystem, shutdownSystem } from "../utils/powermenu"

export function QuickSettings() {
  return (
    <IconButton
      iconName={icons.settings}
      popoverContent={
        <box class="quick-settings-popover" spacing={6}>
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
        </box>
      }
    />
  )
}
