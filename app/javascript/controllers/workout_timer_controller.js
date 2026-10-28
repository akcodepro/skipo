import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-timer"
export default class extends Controller {
  static targets = [
    "exercise",
    "seconds",
    "phase",
    "progressText",
    "dot",
    "form",
    "status",
    "actualDuration",
    "stopButton",
    "pauseButton"
  ]

  static values = { exercises: Array }

  static LABELS = {
    ready: "Get ready!",
    work: "Jump!",
    rest: "Rest",
    done: "Workout complete!",
    cooldown: "Cooldown",
    cooldownMessage: "Nice work. Breathe it out.",
    stopped: "Workout stopped"
  }

  connect() {
    this.index = 0
    this.phase = "ready"
    this.phaseEndsAt = Date.now() + 5 * 1000
    this.workoutStartsAt = this.phaseEndsAt
    this.pausedAt = null

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
        this.hideControls()
        this.finish("completed")
        return
      }

      this.phase = "work"
      this.phaseEndsAt += this.currentExercise().work * 1000
    }
  }

  secondsLeft() {
    return Math.ceil((this.phaseEndsAt - this.now()) / 1000)
  }

  currentExercise() {
    return this.exercisesValue[this.index]
  }

  nextExercise() {
    return this.exercisesValue[this.index + 1] ?? null
  }

  isCooldown() {
    return (
      this.phase === "rest" &&
      this.index === this.exercisesValue.length - 1
    )
  }

  exerciseText() {
    if (this.isCooldown()) {
      return this.constructor.LABELS.cooldownMessage
    }

    if (this.phase === "rest") {
      return this.nextExercise().name
    }

    return this.currentExercise().name
  }

  render() {
    if (this.phase === "done") {
      this.exerciseTarget.textContent = this.constructor.LABELS.done
      this.phaseTarget.textContent = ""
      this.secondsTarget.textContent = "0"
      this.progressTextTarget.textContent = ""
      return
    }

    this.updatePhaseClass()
    this.updateDots()

    const displayIndex = this.displayIndex()

    this.progressTextTarget.textContent =
      `${displayIndex + 1} / ${this.exercisesValue.length}`

    this.exerciseTarget.textContent = this.exerciseText()

    if (this.isCooldown()) {
      this.phaseTarget.textContent = this.constructor.LABELS.cooldown
    } else {
      this.phaseTarget.textContent =
        this.constructor.LABELS[this.phase]
    }

    this.secondsTarget.textContent = this.secondsLeft()
  }

  updatePhaseClass() {
    const phaseClasses = [
      "workout-session--ready",
      "workout-session--jump",
      "workout-session--rest",
      "workout-session--cooldown"
    ]

    this.element.classList.remove(...phaseClasses)

    let phaseClass

    if (this.isCooldown()) {
      phaseClass = "workout-session--cooldown"
    } else if (this.phase === "work") {
      phaseClass = "workout-session--jump"
    } else {
      phaseClass = `workout-session--${this.phase}`
    }

    this.element.classList.add(phaseClass)
  }

  updateDots() {
    const currentIndex = this.displayIndex()

    this.dotTargets.forEach((dot, index) => {
      dot.classList.toggle(
        "workout-session__dot--done",
        index < currentIndex
      )

      dot.classList.toggle(
        "workout-session__dot--current",
        index === currentIndex
      )
    })
  }

  elapsedSeconds() {
    const elapsed = Math.floor(
      (this.now() - this.workoutStartsAt) / 1000
    )

    return Math.max(0, elapsed)
  }

  finish(status) {
    this.statusTarget.value = status
    this.actualDurationTarget.value = this.elapsedSeconds()
    this.formTarget.requestSubmit()
  }

  stop() {
    if (
      !confirm(
        "Are you sure you want to stop? A stopped workout cannot be shared."
      )
    ) {
      return
    }

    clearInterval(this.interval)
    this.hideControls()

    this.phase = "stopped"
    this.exerciseTarget.textContent = this.constructor.LABELS.stopped
    this.phaseTarget.textContent = ""
    this.secondsTarget.textContent = "0"

    this.finish("stopped")
  }

  togglePause() {
    if (this.pausedAt !== null) {
      const pauseDuration = Date.now() - this.pausedAt

      this.phaseEndsAt += pauseDuration
      this.workoutStartsAt += pauseDuration
      this.pausedAt = null

      this.interval = setInterval(() => this.tick(), 1000)

      this.updatePauseButton(false)
    } else {
      this.pausedAt = Date.now()

      clearInterval(this.interval)

      this.updatePauseButton(true)
    }

    this.render()
  }

  updatePauseButton(paused) {
    const button = this.pauseButtonTarget
    const icon = button.querySelector("i")

    if (icon) {
      icon.classList.toggle("fa-pause", !paused)
      icon.classList.toggle("fa-play", paused)
    }

    button.setAttribute(
      "aria-label",
      paused ? "Resume workout" : "Pause workout"
    )
  }

  now() {
    return this.pausedAt ?? Date.now()
  }

  hideControls() {
    this.stopButtonTarget.hidden = true
    this.pauseButtonTarget.hidden = true
  }

  displayIndex() {
    if (this.phase === "rest" && !this.isCooldown()) {
      return this.index + 1
    }

    return this.index
  }
}
