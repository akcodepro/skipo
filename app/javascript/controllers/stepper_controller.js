import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "value",
    "decrementButton",
    "incrementButton"
  ]
  static values = {
    options: Array
  }

  connect() {
    this.updateDisplay()
  }

  increment() {
    const currentValue = Number(this.inputTarget.value)
    const currentIndex = this.optionsValue.indexOf(currentValue)

    if (currentIndex < this.optionsValue.length - 1) {
      this.setValue(this.optionsValue[currentIndex + 1])
    }
  }

  decrement() {
    const currentValue = Number(this.inputTarget.value)
    const currentIndex = this.optionsValue.indexOf(currentValue)

    if (currentIndex > 0) {
      this.setValue(this.optionsValue[currentIndex - 1])
    }
  }

  setValue(seconds) {
    this.inputTarget.value = seconds
    this.updateDisplay()
  }

  updateDisplay() {
    const seconds = Number(this.inputTarget.value)
    const currentIndex = this.optionsValue.indexOf(seconds)

    this.valueTarget.textContent = seconds / 60

    this.decrementButtonTarget.disabled = currentIndex <= 0
    this.incrementButtonTarget.disabled = currentIndex >= this.optionsValue.length - 1
  }
}
