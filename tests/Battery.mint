component Test.Battery {
  state isCharging = false
  state chargingTime = 0
  state dischargingTime = 0
  state level = 0
  state battery : Maybe(Battery) = Maybe::Nothing

  fun componentDidMount {
    let battery =
      await `window.navigator.getBattery()` as Battery

    let isCharging =
      await Battery.isCharging()

    let chargingTime =
      await Battery.chargingTime()

    let dischargingTime =
      await Battery.dischargingTime()

    let level =
      await Battery.level()

    next
      {
        battery: Maybe::Just(battery),
        isCharging: isCharging,
        chargingTime: chargingTime,
        dischargingTime: dischargingTime,
        level: level
      }
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

suite "Battery" {
  test "it returns the correct values" {
    <Test.Battery/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("charging", "true")
    |> Test.Html.assertTextOf("chargingtime", "true")
    |> Test.Html.assertTextOf("dischargingtime", "true")
    |> Test.Html.assertTextOf("level", "true")
  }
}
