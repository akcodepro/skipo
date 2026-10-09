import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static targets = [ "exercise", "seconds", "phase" ]

  static values = { exercises: Array }

  connect() {
    this.index = 0
    this.phase = "Get ready!"
    this.secondsLeft = 5

    this.render()

    this.interval = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  tick() {
    this.secondsLeft -= 1

    if (this.secondsLeft <= 0) {
      this.advance()
    }

    this.render()
  }

  advance() {
    if (this.phase === "Get ready!") {
      this.phase = "work"
      this.secondsLeft = this.currentExercise().work
    } else if (this.phase === "work") {
      this.phase = "rest"
      this.secondsLeft = this.currentExercise().rest
    } else if (this.phase === "rest") {
      this.index += 1
      if (this.index >= this.exercisesValue.length) {
        clearInterval(this.interval)
        this.phase = "done"
        return
      }
      this.phase = "work"
      this.secondsLeft = this.currentExercise().work
    }
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

    this.secondsTarget.textContent = this.secondsLeft
  }
}
