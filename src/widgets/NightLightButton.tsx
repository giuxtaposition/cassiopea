import { createSubprocess, execAsync } from "ags/process"
import { icons } from "../lib/icons"
import { QuickSettingsButton } from "../components/QuickSettingsButton"

const MAX_TEMP = 6500
const SHIELD_TEMP = 5000

const nightLightEnabled = createSubprocess(
  false,
  "wl-gammarelay-rs watch {t}",
  (result) => {
    return parseInt(result) !== MAX_TEMP
  },
)

async function toggleNightLight() {
  let newTemperature: number

  if (nightLightEnabled.peek()) {
    newTemperature = MAX_TEMP
  } else {
    newTemperature = SHIELD_TEMP
  }

  await execAsync(
    `busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q ${newTemperature}`,
  )
}

export function NightLightButton() {
  return (
    <QuickSettingsButton
      onClick={toggleNightLight}
      iconName={nightLightEnabled((enabled) =>
        enabled ? icons.nightLight.enabled : icons.nightLight.disabled,
      )}
      active={nightLightEnabled}
      label={nightLightEnabled((enabled) =>
        enabled ? "Night Light On" : "Night Light Off",
      )}
    />
  )
}
