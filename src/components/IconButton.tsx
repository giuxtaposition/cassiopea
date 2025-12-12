import { Gtk } from "gi://Gtk?version=4.0"
import { Accessor } from "gnim"
import GObject from "gnim/gobject"

export function IconButton({
  iconName,
  popoverContent,
  onClick,
  visible = true,
  $popover: $popover,
  tooltip,
  size = 20,
}: {
  iconName: string | Accessor<string>
  popoverContent?: GObject.Object
  onClick?: () => void
  visible?: boolean | Accessor<boolean>
  $popover?: (self: Gtk.Popover) => void
  tooltip?: string | Accessor<string>
  size?: number
}) {
  if (popoverContent) {
    return (
      <menubutton class="icon-button" visible={visible} tooltipText={tooltip}>
        <image iconName={iconName} pixelSize={size} />
        <popover $={$popover}>{popoverContent}</popover>
      </menubutton>
    )
  }

  return (
    <button
      class="icon-button"
      onClicked={onClick}
      visible={visible}
      tooltipText={tooltip}
    >
      <image iconName={iconName} pixelSize={size} />
    </button>
  )
}
