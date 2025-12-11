import { Accessor } from "gnim"

export function IconIndicator({
  iconName,
  visible = true,
  tooltip,
}: {
  iconName: string | Accessor<string>
  visible?: boolean | Accessor<boolean>
  tooltip?: string | Accessor<string>
}) {
  return (
    <box class="icon-indicator blink" visible={visible} tooltipText={tooltip}>
      <image iconName={iconName} pixelSize={20} />
    </box>
  )
}
