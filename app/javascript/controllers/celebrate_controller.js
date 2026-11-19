import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    const fire = confetti.create(this.canvasTarget, { resize: true, disableForReducedMotion: true })

    fire({
    particleCount: 100,
    spread: 70,
    origin: { y: 0.6 },
    colors: [ "#F27C45", "#F4CF45", "#F7F5EF", "#AAA3AB" ],
    shapes: [ "circle", "square", "star" ] })
  }
}
