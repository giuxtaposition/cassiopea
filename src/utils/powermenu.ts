import { execAsync } from "ags/process"

export async function shutdownSystem() {
  try {
    await execAsync(["bash", "-c", "systemctl poweroff"])
  } catch (error) {
    console.error(error)
  }
}

export async function rebootSystem() {
  try {
    await execAsync(["bash", "-c", "systemctl reboot"])
  } catch (error) {
    console.error(error)
  }
}
