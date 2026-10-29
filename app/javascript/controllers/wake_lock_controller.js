import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.wakeLock = null

    document.addEventListener(
      "visibilitychange",
      this.handleVisibility
    )

    this.request()
  }

  disconnect() {
    document.removeEventListener(
      "visibilitychange",
      this.handleVisibility
    )

    this.wakeLock?.release()
    this.wakeLock = null
  }

  handleVisibility = () => {
    if (document.visibilityState === "visible") {
      this.request()
    }
  }

  async request() {
    if (!("wakeLock" in navigator)) return

    try {
      this.wakeLock = await navigator.wakeLock.request("screen")
    } catch (error) {
      console.warn("Unable to acquire screen wake lock:", error)
    }
  }
}
