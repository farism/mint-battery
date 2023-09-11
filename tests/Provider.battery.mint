component Test.Provider.Battery {
  state isCharging = false
  state chargingTime = 0
  state dischargingTime = 0
  state level = 0
  state battery : Maybe(Battery) = Maybe::Nothing

  use Provider.Battery {
    changes:
      (
        isCharging : Bool,
        chargingTime : Number,
        dischargingTime : Number,
        level : Number
      ) : Promise(Void) {
        next
          {
            isCharging: isCharging,
            chargingTime: chargingTime,
            dischargingTime: dischargingTime,
            level: level
          }
      }
  }

  fun componentDidMount {
    let battery =
      await `window.navigator.getBattery()` as Battery

    next { battery: Maybe::Just(battery) }
  }

  fun render : Html {
    case battery {
      Maybe::Just(battery) =>
        <>
          <charging>
            <{ Bool.toString(isCharging == `#{battery}.charging`) }>
          </charging>

          <chargingtime>
            <{ Bool.toString(chargingTime == `#{battery}.chargingTime`) }>
          </chargingtime>

          <dischargingtime>
            <{ Bool.toString(dischargingTime == `#{battery}.dischargingTime`) }>
          </dischargingtime>

          <level>
            <{ Bool.toString(level == `#{battery}.level`) }>
          </level>
        </>

      => <div/>
    }
  }
}

suite "Provider.Battery" {
  test "it returns the correct values" {
    <Test.Provider.Battery/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("charging", "true")
    |> Test.Html.assertTextOf("chargingtime", "true")
    |> Test.Html.assertTextOf("dischargingtime", "true")
    |> Test.Html.assertTextOf("level", "true")
  }
}
