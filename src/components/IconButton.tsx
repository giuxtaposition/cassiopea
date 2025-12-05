import GObject from "gnim/gobject"

export function IconButton({
  iconName,
  popoverContent,
  onClick,
}: {
  iconName: string
  popoverContent?: GObject.Object
  onClick?: () => void
}) {
  if (popoverContent) {
    return (
      <menubutton class="icon-button">
        <image iconName={iconName} pixelSize={20} />
        <popover>{popoverContent}</popover>
      </menubutton>
    )
  }

  return (
    <button class="icon-button" onClicked={onClick}>
      <image iconName={iconName} pixelSize={20} />
    </button>
  )
}
