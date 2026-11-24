
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "icon", "text"]

  show(event) {
    const file = event.target.files[0]
    if (!file) return

    this.imageTarget.src = URL.createObjectURL(file)
    this.imageTarget.hidden = false
    this.iconTarget.setAttribute("hidden", "")
    this.textTarget.textContent = "Change photo"
  }
}
