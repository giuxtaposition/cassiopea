import { IconButton } from "../components/IconButton"
import { icons } from "../lib/icons"
import { toggleWindow } from "../utils/window"

export function SearchApps() {
  return (
    <IconButton
      iconName={icons.search}
      onClick={() => {
        toggleWindow("applauncher")
      }}
    />
  )
}
