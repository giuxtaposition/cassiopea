import Gtk from "gi://Gtk?version=4.0"
import AstalNetwork from "gi://AstalNetwork"
import { For, With, createBinding, createComputed } from "ags"
import { icons } from "../lib/icons"
import { IconButton } from "../components/IconButton"

export function WifiIndicator() {
  const network = AstalNetwork.get_default()
  const wifi = createBinding(network, "wifi")
  const ssid = createBinding(network.wifi, "ssid")

  const WifiIcon = createComputed(() => {
    const internet = createBinding(network, "wifi", "internet")()
    const strength = createBinding(network, "wifi", "strength")()
    const enabled = createBinding(network, "wifi", "enabled")()

    if (!enabled || internet === AstalNetwork.Internet.DISCONNECTED) {
      return icons.network.wifi.disabled
    }

    return getIconNameForStrength(strength)
  })

  function getIconNameForStrength(strength: number) {
    if (strength < 26) {
      return icons.network.wifi.weak
    } else if (strength < 51) {
      return icons.network.wifi.ok
    } else if (strength < 76) {
      return icons.network.wifi.good
    } else {
      return icons.network.wifi.excellent
    }
  }

  const sorted = (arr: Array<AstalNetwork.AccessPoint>) => {
    return arr
      .filter((ap) => !!ap.ssid && ap.strength > 0)
      .sort((a, b) => b.strength - a.strength)
      .sort((a, b) => Number(ssid() === b.ssid) - Number(ssid() === a.ssid))
  }

  async function connect(ap: AstalNetwork.AccessPoint) {
    let pw: string | null = null

    if (ap.get_connections().length == 0 && ap.requiresPassword) {
      //TODO
      // popup asking for password
    }

    return new Promise((resolve, reject) => {
      ap.activate(pw, (_, res) => {
        try {
          resolve(ap.activate_finish(res))
        } catch (error) {
          reject(error)
        }
      })
    })
  }

  function formatToHz(freq: number) {
    return `(${(freq / 1000).toFixed(1)} GHz)`
  }

  return (
    <box visible={wifi(Boolean)}>
      <With value={wifi}>
        {(wifi) =>
          wifi && (
            <IconButton
              iconName={WifiIcon}
              popoverContent={
                <box orientation={Gtk.Orientation.VERTICAL}>
                  <For each={createBinding(wifi, "accessPoints")(sorted)}>
                    {(ap: AstalNetwork.AccessPoint) => (
                      <button onClicked={() => connect(ap)}>
                        <box spacing={4}>
                          <image
                            iconName={createBinding(
                              ap,
                              "strength",
                            )((strength) => getIconNameForStrength(strength))}
                          />
                          <label label={createBinding(ap, "ssid")} />
                          <label
                            label={createBinding(ap, "frequency")(formatToHz)}
                          />
                          <image
                            iconName={icons.checkmark}
                            visible={createBinding(
                              wifi,
                              "activeAccessPoint",
                            )((active) => active === ap)}
                          />
                        </box>
                      </button>
                    )}
                  </For>
                </box>
              }
            />
          )
        }
      </With>
    </box>
  )
}
