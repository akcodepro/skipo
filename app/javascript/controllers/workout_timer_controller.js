import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static targets = [ "exercise", "seconds", "phase" ]

  static values = { exercises: Array }

  connect() {
    this.phaseTarget.textContent = "Get ready"
    console.log(this.exercisesValue)
  }
}
