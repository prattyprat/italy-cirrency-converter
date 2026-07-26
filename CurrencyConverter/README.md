# Currency Converter

A simple SwiftUI iOS app that converts between five currencies at once:
USD, HKD, INR, EUR, and CHF.

Type a number into any of the five boxes and the other four update
instantly with the converted amount.

## Opening the project

1. Open `CurrencyConverter.xcodeproj` in Xcode (15 or later recommended).
2. Select the `CurrencyConverter` scheme and a simulator (or your device).
3. In the target's *Signing & Capabilities* tab, set your own Team if
   running on a physical device.
4. Press Run.

## How it works

- `Currency.swift` defines the five currencies, their display symbol/name,
  and a fixed exchange rate expressed as "units per 1 USD".
- `ConverterModel.swift` holds the text for each of the five boxes. When
  one box changes, it converts that value to USD and then re-derives the
  other four boxes from that USD amount.
- `ContentView.swift` renders the five boxes and a keyboard "Done" button.

## Updating exchange rates

Rates are fixed in the app (not fetched live) so it works offline. To
refresh them, edit the `unitsPerUSD` values in `Currency.swift`.
