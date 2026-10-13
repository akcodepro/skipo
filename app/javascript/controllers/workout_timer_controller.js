import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static targets = ["exercise", "seconds", "phase"]

  static values = { exercises: Array }

  connect() {
    console.log("Workout timer connected")
    this.index = 0
    this.phase = "Get ready!"
    this.phaseEndsAt = Date.now() + 5 * 1000

    this.render()

    this.interval = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    console.log("Workout timer disconnected")
    clearInterval(this.interval)
  }

  tick() {
    while (this.secondsLeft() <= 0 && this.phase !== "done") {
      this.advance()
    }

    this.render()
  }

  advance() {
    if (this.phase === "Get ready!") {
      this.phase = "work"
      this.phaseEndsAt += this.currentExercise().work * 1000
    } else if (this.phase === "work") {
      this.phase = "rest"
      this.phaseEndsAt += this.currentExercise().rest * 1000
    } else if (this.phase === "rest") {
      this.index += 1

      if (this.index >= this.exercisesValue.length) {
        clearInterval(this.interval)
        this.phase = "done"
        return
      }

      this.phase = "work"
      this.phaseEndsAt += this.currentExercise().work * 1000
    }
  }

  secondsLeft() {
    return Math.ceil((this.phaseEndsAt - Date.now()) / 1000)
  }

  currentExercise() {
    return this.exercisesValue[this.index]
  }

  render() {
    if (this.phase === "done") {
      this.exerciseTarget.textContent = "Workout complete!"
      this.phaseTarget.textContent = this.phase
      this.secondsTarget.textContent = "0"
      return
    }

    this.exerciseTarget.textContent = this.currentExercise().name

    if (
      this.phase === "rest" &&
      this.index === this.exercisesValue.length - 1
    ) {
      this.phaseTarget.textContent = "cooldown"
    } else {
      this.phaseTarget.textContent = this.phase
    }

    this.secondsTarget.textContent = this.secondsLeft()
  }
}
