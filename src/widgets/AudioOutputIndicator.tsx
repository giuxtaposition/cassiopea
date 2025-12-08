import AstalWp from "gi://AstalWp"
import { createBinding } from "ags"
import { IconButton } from "../components/IconButton"

export function AudioOutputIndicator() {
  const { defaultSpeaker: speaker } = AstalWp.get_default()

  return (
    <IconButton
      iconName={createBinding(
        speaker,
        "volumeIcon",
      )((v) => v.replace("audio-", ""))}
      popoverContent={
        <box>
          <slider
            widthRequest={200}
            onChangeValue={({ value }) => speaker.set_volume(value)}
            value={createBinding(speaker, "volume")}
          />
        </box>
      }
    />
  )
}
