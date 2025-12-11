import { createPoll } from "ags/time"
import { Accessor } from "gnim"

export const isScreenSharing: Accessor<boolean> = createPoll(
  false,
  1000,
  'bash -c "pactl -f json list clients"',
  function (result: string) {
    const clients = JSON.parse(result)
    return clients.some(
      (client: any) => client.properties?.["pipewire.access"] === "portal",
    )
  },
)
