import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static values = {
    exercises: Array
  }

  connect() {
    console.log(this.exercisesValue)
  }
}
