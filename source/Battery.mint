module Battery {
  /* Returns the amount of time, in seconds, that remain until the battery is fully charged or `0` if the battery is already fully charged. If the battery is currently discharging, its value is `Infinity`. */
  fun chargingTime : Promise(Number) {
    case await get() {
      Maybe::Just(b) => `#{b}.chargingTime`
      => Maybe.withDefault(Number.fromString("Infinity"), 0)
    }
  }

  /* Returns the amount of time, in seconds, that remains until the battery is fully discharged, or `Infinity` if the battery is currently charging rather than discharging, or if the system is unable to report the remaining discharging time. */
  fun dischargingTime : Promise(Number) {
    case await get() {
      Maybe::Just(b) => `#{b}.dischargingTime`
      => Maybe.withDefault(Number.fromString("Infinity"), 0)
    }
  }

  /* Returns a Promise which may resolve to a `BatteryManager` instance */
  fun get : Promise(Maybe(Battery)) {
    await `
    (() => {
      return window.navigator
        .getBattery()
        .then(($battery) => #{Maybe::Just(`$battery`)})
        .catch(() => #{Maybe::Nothing})
    })()
    `
  }

  /* Returns a boolean value indicating whether or not the device's battery is currently being charged. */
  fun isCharging : Promise(Bool) {
    case await get() {
      Maybe::Just(b) => `#{b}.charging`
      => true
    }
  }

  /* Returns the current battery charge level as a value between `0.0` and `1.0`. A value of `0.0` means the battery is empty and the system is about to be suspended. A value of `1.0` means the battery is full. A value of `1.0` is also returned if the implementation isn't able to determine the battery charge level or if the system is not battery-powered. */
  fun level : Promise(Number) {
    case await get() {
      Maybe::Just(b) => `#{b}.level`
      => 1
    }
  }
}
