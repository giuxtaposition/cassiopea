import { IconButton } from "../components/IconButton"
import { toggleWindow } from "../utils/window"

export function SearchApps() {
  return (
    <IconButton
      iconName="system-search-symbolic"
      onClick={() => {
        toggleWindow("applauncher")
      }}
    />
  )
}
