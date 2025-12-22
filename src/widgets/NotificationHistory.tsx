import { Gtk } from "ags/gtk4"
import AstalNotifd from "gi://AstalNotifd"
import Notification from "./Notification"
import { For, createState, onCleanup } from "ags"

export default function NotificationHistory() {
  const notifd = AstalNotifd.get_default()
  const [notifications, setNotifications] = createState(
    new Array<AstalNotifd.Notification>(),
  )

  const notifiedHandler = notifd.connect("notified", (_, id, replaced) => {
    console.log("NotificationHistory notified:", id, replaced)
    const notification = notifd.get_notification(id)
    if (!notification) return

    if (replaced && notifications.peek().some((n) => n.id === id)) {
      setNotifications((ns) => ns.map((n) => (n.id === id ? notification : n)))
    } else {
      setNotifications((ns) => [notification, ...ns])
    }
  })

  function deleteNotification(id: number) {
    setNotifications((ns) => ns.filter((n) => n.id !== id))
  }

  onCleanup(() => {
    notifd.disconnect(notifiedHandler)
  })

  return (
    <box
      orientation={Gtk.Orientation.VERTICAL}
      visible={notifications((ns) => ns.length > 0)}
    >
      <label label="Notification History" class="section-title" />
      <For each={notifications}>
        {(notification) => (
          <Notification
            notification={notification}
            deleteNotification={deleteNotification}
          />
        )}
      </For>
    </box>
  )
}
