/* Represents a subscription for `Provider.Battery` */
record Provider.Battery.Subscription {
  changes : Function(Bool, Number, Number, Number, Promise(Void))
}

/* A provider for the `[BatteryManager](https://developer.mozilla.org/docs/Web/API/BatteryManager)` API. */
provider Provider.Battery : Provider.Battery.Subscription {
  state battery : Maybe(Battery) = Maybe::Nothing

  fun change {
    notify(battery)
  }

  fun notify (battery : Maybe(Battery)) {
    case battery {
      Maybe::Just(b) =>
        for subscription of subscriptions {
          subscription.changes(`#{b}.charging`, `#{b}.chargingTime`, `#{b}.dischargingTime`, `#{b}.level`)
        }

      => []
    }
  }

  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      next { }
    } else if battery == Maybe::Nothing {
      let battery =
        await Battery.get()

      notify(battery)

      case battery {
        Maybe::Just(b) =>
          {
            `#{b}.addEventListener('chargingchange', #{change})`
            `#{b}.addEventListener('chargingtimechange', #{change})`
            `#{b}.addEventListener('dischargingtimechange', #{change})`
            `#{b}.addEventListener('levelchange', #{change})`
          }

        =>
          { }
      }

      next { battery: battery }
    } else {
      next { }
    }
  }
}
