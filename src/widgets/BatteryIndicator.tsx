import Gtk from "gi://Gtk?version=4.0"
import AstalBattery from "gi://AstalBattery"
import AstalPowerProfiles from "gi://AstalPowerProfiles"
import { createBinding, createComputed } from "ags"
import { IconButton } from "../components/IconButton"
import { icons } from "../lib/icons"

export function BatteryIndicator() {
  let popover: Gtk.Popover
  const battery = AstalBattery.get_default()
  const powerProfiles = AstalPowerProfiles.get_default()

  const setProfile = (profile: string) => {
    powerProfiles.set_active_profile(profile)
  }

  const BatteryIcon = createComputed(() => {
    const percentage = createBinding(battery, "percentage")()
    const state = createBinding(battery, "state")()

    if (
      state === AstalBattery.State.CHARGING ||
      state === AstalBattery.State.FULLY_CHARGED
    ) {
      return icons.battery.charging
    } else {
      if (percentage <= 0.25) {
        return icons.battery.level1
      } else if (percentage <= 0.5) {
        return icons.battery.level2
      } else if (percentage <= 0.75) {
        return icons.battery.level3
      } else {
        return icons.battery.level4
      }
    }
  })

  return (
    <IconButton
      visible={createBinding(battery, "isPresent")}
      iconName={BatteryIcon}
      $popover={(self) => (popover = self)}
      tooltip={createBinding(
        battery,
        "percentage",
      )((p) => `${Math.round(p * 100)}%`)}
      popoverContent={
        <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
          {powerProfiles.get_profiles().map(({ profile }) => (
            <button
              onClicked={() => {
                setProfile(profile)
                popover.hide()
              }}
              class="menubutton"
            >
              <label label={profile} xalign={0} />
            </button>
          ))}
        </box>
      }
    />
  )
}
