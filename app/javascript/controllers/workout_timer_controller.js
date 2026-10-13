import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static targets = [
    "exercise",
    "seconds",
    "phase",
    "progress",
    "progressText",
    "form",
    "status",
    "actualDuration"
  ]

  static values = { exercises: Array }

  static LABELS = {
    ready: "Get ready!",
    work: "Jump!",
    rest: "Rest",
    done: "Workout complete!",
    cooldown: "Cooldown"
  }

  connect() {
    this.index = 0
    this.phase = "ready"
    this.phaseEndsAt = Date.now() + 5 * 1000
    this.workoutStartsAt = this.phaseEndsAt

    this.render()

    this.interval = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  tick() {
    while (this.secondsLeft() <= 0 && this.phase !== "done") {
      this.advance()
    }

    this.render()
  }

  advance() {
    if (this.phase === "ready") {
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
        this.finish("completed")
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
      this.exerciseTarget.textContent = this.constructor.LABELS.done
      this.phaseTarget.textContent = ""
      this.secondsTarget.textContent = "0"
      this.progressTarget.value = this.progressTarget.max
      this.progressTextTarget.textContent = ""
      return
    }

    this.progressTarget.value = this.elapsedSeconds()
    this.progressTextTarget.textContent = `${this.index + 1} of ${this.exercisesValue.length}`

    this.exerciseTarget.textContent = this.currentExercise().name

    if (this.phase === "rest" && this.index === this.exercisesValue.length - 1) {
      this.phaseTarget.textContent = this.constructor.LABELS.cooldown
    } else {
      this.phaseTarget.textContent = this.constructor.LABELS[this.phase]
    }

    this.secondsTarget.textContent = this.secondsLeft()
  }

  elapsedSeconds() {
    const elapsed = Math.floor(
      (Date.now() - this.workoutStartsAt) / 1000
    )
    return Math.max(0, Math.min(elapsed, Number(this.progressTarget.max)))
  }

  finish(status) {
    this.statusTarget.value = status
    this.actualDurationTarget.value = this.elapsedSeconds()
    this.formTarget.requestSubmit()
  }
}
