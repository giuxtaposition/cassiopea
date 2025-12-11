import { IconIndicator } from "../components/IconIndicator"
import { icons } from "../lib/icons"
import { isScreenSharing } from "../utils/screen-sharing"

export function ScreenSharingIndicator() {
  return (
    <IconIndicator visible={isScreenSharing} iconName={icons.screenSharing} />
  )
}
