import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["summary", "compose"]

  open() {
    this.summaryTarget.hidden = true
    this.composeTarget.hidden = false
  }

  back() {
    this.summaryTarget.hidden = false
    this.composeTarget.hidden = true
  }
}
