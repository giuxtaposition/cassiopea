import { Gtk } from "ags/gtk4"
import { createBinding, createComputed, For } from "ags"
import AstalMpris from "gi://AstalMpris"
import { icons } from "../lib/icons"
import { AudioVisualizer } from "./AudioVisualizer"

function truncate(text: string, maxLength = 20): string {
  if (text.length <= maxLength) {
    return text
  }
  return text.slice(0, maxLength - 3) + "..."
}

const musicPlayers = ["spotify"]

export const mediaPlayerWidgetIsVisible = createComputed(() => {
  const mpris = AstalMpris.get_default()
  const players = createBinding(mpris, "players")()
  return !!players.find((player) => musicPlayers.includes(player.entry))
})

export function MediaPlayer() {
  const mpris = AstalMpris.get_default()
  const players = createBinding(mpris, "players")

  return (
    <box spacing={4} orientation={Gtk.Orientation.VERTICAL}>
      <For each={players}>
        {(player) => (
          <box
            visible={musicPlayers.includes(player.entry)}
            spacing={6}
            orientation={Gtk.Orientation.HORIZONTAL}
          >
            <box>
              <AudioVisualizer />
            </box>
            <box>
              <button
                onClicked={() => player.previous()}
                visible={createBinding(player, "canGoPrevious")}
              >
                <image iconName={icons.media.previous} />
              </button>
              <button
                onClicked={() => player.play_pause()}
                visible={createBinding(player, "canControl")}
              >
                <box>
                  <image
                    iconName={icons.media.play}
                    visible={createBinding(
                      player,
                      "playbackStatus",
                    )((s) => s !== AstalMpris.PlaybackStatus.PLAYING)}
                  />
                  <image
                    iconName={icons.media.pause}
                    visible={createBinding(
                      player,
                      "playbackStatus",
                    )((s) => s === AstalMpris.PlaybackStatus.PLAYING)}
                  />
                </box>
              </button>
              <button
                onClicked={() => player.next()}
                visible={createBinding(player, "canGoNext")}
              >
                <image iconName={icons.media.next} />
              </button>
            </box>
            <box
              valign={Gtk.Align.CENTER}
              orientation={Gtk.Orientation.VERTICAL}
            >
              <label
                xalign={0}
                label={createBinding(player, "title").as((t) => truncate(t))}
              />
              <label xalign={0} label={createBinding(player, "artist")} />
            </box>
          </box>
        )}
      </For>
    </box>
  )
}
