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
    /// other field from this one so all five boxes stay in sync.
    func update(_ currency: Currency, to text: String) {
        guard !isUpdating else { return }
        isUpdating = true
        defer { isUpdating = false }

        amounts[currency] = text

        let sanitized = text.replacingOccurrences(of: ",", with: "")
        guard !sanitized.isEmpty, let enteredValue = Double(sanitized) else {
            for other in Currency.allCases where other != currency {
                amounts[other] = ""
            }
            return
        }

        let usdValue = enteredValue / currency.unitsPerUSD
        for other in Currency.allCases where other != currency {
            let converted = usdValue * other.unitsPerUSD
            amounts[other] = Self.format(converted)
        }
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
