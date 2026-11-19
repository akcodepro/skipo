import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    const fire = confetti.create(this.canvasTarget, {
      resize: true,
      disableForReducedMotion: true
    })

    const wave = confetti.shapeFromPath({ path: "M0 6 Q5 0 10 6 T20 6 T30 6 L30 10 Q25 4 20 10 T10 10 T0 10 Z" })
    const s = confetti.shapeFromPath({ path: "M61.337,39.304C75.013,28.172 116.537,13.879 136.502,14.446C145.875,14.713 149.018,20.896 147.539,26.511C145.987,32.406 142.361,35.063 141.681,35.696C131.95,44.766 110.237,46.048 106.59,53.547C103.587,59.723 109.86,63.758 110.628,64.318C114.637,67.238 131.824,73.754 138.64,77.219C151.3,83.656 163.619,92.86 164.1,103.528C164.515,112.739 155.959,118.983 155.437,119.428C144.825,128.473 105.305,146.095 67.573,155.796C37.042,163.645 29.445,159.869 25.487,157.52C21.284,155.025 19.829,149.477 20.808,144.568C24.237,127.372 40.958,113.82 48.475,110.449C70.913,100.385 84.93,108.254 100.456,106.138C108.009,105.108 111.147,99.993 107.027,94.862C105.676,93.18 105.567,93.296 103.786,92.074C94.176,85.478 86.06,84.573 69.709,75.143C67.549,73.898 51.649,63.367 53.551,51.509C54.64,44.717 60.572,39.987 61.337,39.304Z" })

    // Settings every burst shares
    const defaults = {
      spread: 45,
      startVelocity: 62,
      gravity: 1,
      ticks: 220,
      decay: 0.92,
      scalar: 1.3,
      colors: [ "#F27C45", "#F4CF45", "#F7F5EF" ],
      shapes: [ wave, "square", "circle" ]
    }

    // The S gets its own look: bigger, no tumbling, brand colours only
    const brand = {
      shapes: [ s ],
      scalar: 2.4,
      flat: true,
      colors: [ "#F27C45", "#F4CF45" ]
    }

    // Fires from both bottom corners at once
    const cannons = (extra) => {
      fire({ ...defaults, ...extra, angle: 70, origin: { x: 0, y: 1 } })
      fire({ ...defaults, ...extra, angle: 110, origin: { x: 1, y: 1 } })
    }

    // First wave
    cannons({ particleCount: 60 })
    cannons({ ...brand, particleCount: 8 })

    // Second wave, a quarter of a second later
    setTimeout(() => {
      cannons({ particleCount: 40 })
      cannons({ ...brand, particleCount: 5 })
    }, 250)
  }
}
