import { Accessor } from "gnim"
import { icons } from "../lib/icons"

export function MenuButton({
  onClicked,
  iconName,
  active,
  labels,
}: {
  onClicked: () => void
  iconName?: string | Accessor<string>
  active?: boolean | Accessor<boolean>
  labels: (string | Accessor<string>)[]
}) {
  return (
    <button onClicked={onClicked} class="menubutton">
      <box spacing={4}>
        {iconName && <image iconName={iconName} />}
        {labels.map((label) => (
          <label label={label} />
        ))}
        <image iconName={icons.checkmark} visible={active} />
      </box>
    </button>
  )
}
