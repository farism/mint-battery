# Mint Battery

[![CI](https://github.com/farism/mint-battery/actions/workflows/ci.yml/badge.svg)](https://github.com/farism/mint-battery/actions/workflows/ci.yml)

[Mint](https://mint-lang.com/) wrapper for the browser [BatteryManager API](https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager)

# API

The API is split into two parts, the `Battery` module and the `Provider.Battery` provider.

# `Battery.Provider`

The `Battery.Provider` provider provides change events to the subscriber. Events will fire when `charging`, `chargingTime`, `dischargingTime`, or `level` values change.

Example of using the provider

```mint
component Main {
  state level = 0

  use Provider.Battery {
    changes:
      (
        isCharging : Bool,
        chargingTime : Number,
        dischargingTime : Number,
        level : Number
      ) : Promise(Void) {
        next { level: level }
      }
  }

  fun render : Html {
    <div>"#{level}"</div>
  }
}
```

# `Battery`

The `Battery` module provides direcet access to the Battery information. 

All functions return a promise, because the underlying browser API to retrieve the `BatteryManager` with `window.navigator.getBattery()` returns a promise.

- `get()` - Retrieves the underlying `BatteryManager`

- `isCharging()` - Returns whether the device is currently charging

- `chargingTime()` - Returns the time left in seconds to fully charge

- `dischargingTime()` - Returns the time left in seconds to fully discharge

- `level()` - Returns the current battery level

Example using the `Battery` module

```mint
component Main {
  state level = 0

  fun componentDidMount {
    let level =
      await Battery.level()

    next { level: level }
  }

  fun render : Html {
    <div>"#{level}"</div>
  }
}
```