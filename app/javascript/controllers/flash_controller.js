import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 0 } }

  connect() {
    if (this.timeoutValue > 0) {
      this.timer = setTimeout(() => this.dismiss(), this.timeoutValue)
    }
  }

  dismiss() {
    clearTimeout(this.timer)
    this.element.classList.add("flash--dismissing")

    setTimeout(() => this.element.remove(), 300)
  }
}
