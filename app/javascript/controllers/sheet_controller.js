import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    if (!this.dialogTarget.open) {
      this.dialogTarget.showModal()
    }
  }

  close() {
    this.dialogTarget.close()
    this.frameTarget.innerHTML = ""
    this.frameTarget.removeAttribute("src")
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
