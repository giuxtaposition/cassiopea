import { Accessor } from "gnim"

export function QuickSettingsButton({
  onClick,
  iconName,
  active,
  label,
}: {
  onClick: () => void
  iconName: string | Accessor<string>
  active: Accessor<boolean>
  label: string | Accessor<string>
}) {
  return (
    <box class="quick-settings-button">
      <button onClicked={onClick}>
        <box spacing={6}>
          <image
            iconName={iconName}
            class={active((active) => (active ? "active" : ""))}
            pixelSize={20}
          />
          <label label={label} />
        </box>
      </button>
    </box>
  )
}
