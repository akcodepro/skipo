import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panels", "dot"]

  update() {
    const index = Math.round(
      this.panelsTarget.scrollLeft / this.panelsTarget.clientWidth
    )

    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle("activity__dot--active", i === index)
    })
  }

  go(event) {
    const index = Number(event.currentTarget.dataset.index)

    this.panelsTarget.scrollTo({
      left: index * this.panelsTarget.clientWidth,
      behavior: "smooth"
    })
  }
}
