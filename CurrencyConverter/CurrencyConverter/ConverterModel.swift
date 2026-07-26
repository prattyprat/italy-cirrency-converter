import Foundation

@MainActor
final class ConverterModel: ObservableObject {
    @Published var amounts: [Currency: String]

    private var isUpdating = false

    init() {
        var initial: [Currency: String] = [:]
        for currency in Currency.allCases {
            initial[currency] = ""
        }
        amounts = initial
    }

    /// Called when the user edits the field for `currency`. Recomputes every
    /// other field from this one so all five boxes stay in sync. The typed
    /// text may be a plain number or an arithmetic expression (e.g. "12+3*2").
    func update(_ currency: Currency, to text: String) {
        guard !isUpdating else { return }
        isUpdating = true
        defer { isUpdating = false }

        amounts[currency] = text

        let sanitized = text.replacingOccurrences(of: ",", with: "")
        guard !sanitized.isEmpty else {
            for other in Currency.allCases where other != currency {
                amounts[other] = ""
            }
            return
        }

        // An expression like "12+" is incomplete while still being typed;
        // leave the other boxes alone until it evaluates to something.
        guard let enteredValue = ExpressionEvaluator.evaluate(sanitized) else {
            return
        }

        let usdValue = enteredValue / currency.unitsPerUSD
        for other in Currency.allCases where other != currency {
            let converted = usdValue * other.unitsPerUSD
            amounts[other] = Self.format(converted)
        }
    }

    /// Collapses a box's typed expression down to its evaluated result, e.g.
    /// "12+3*2" becomes "18". Call this when the box loses focus.
    func commit(_ currency: Currency) {
        guard !isUpdating else { return }
        let sanitized = (amounts[currency] ?? "").replacingOccurrences(of: ",", with: "")
        guard let value = ExpressionEvaluator.evaluate(sanitized) else { return }
        isUpdating = true
        amounts[currency] = Self.format(value)
        isUpdating = false
    }

    /// Resets every box back to "0".
    func clearAll() {
        isUpdating = true
        for currency in Currency.allCases {
            amounts[currency] = "0"
        }
        isUpdating = false
    }

    private static func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}
