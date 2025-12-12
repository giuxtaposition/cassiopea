import { icons } from "../lib/icons"
import { QuickSettingsButton } from "../components/QuickSettingsButton"
import AstalNotifd from "gi://AstalNotifd"
import { createBinding } from "ags"

const notifd = AstalNotifd.get_default()

export function DoNotDisturbButton() {
  return (
    <QuickSettingsButton
      onClick={async () => {
        notifd.set_dont_disturb(!notifd.get_dont_disturb())
      }}
      iconName={createBinding(notifd, "dont_disturb").as((enabled) =>
        enabled ? icons.notifications.disabled : icons.notifications.enabled,
      )}
      active={createBinding(notifd, "dont_disturb")}
      label={createBinding(notifd, "dont_disturb").as((enabled) =>
        enabled ? "Do Not Disturb On" : "Do Not Disturb Off",
      )}
    />
  )
}
