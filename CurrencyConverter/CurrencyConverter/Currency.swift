import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case hkd = "HKD"
    case inr = "INR"
    case eur = "EUR"
    case chf = "CHF"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .usd: return "$"
        case .hkd: return "HK$"
        case .inr: return "₹"
        case .eur: return "€"
        case .chf: return "Fr"
        }
    }

    var displayName: String {
        switch self {
        case .usd: return "US Dollar"
        case .hkd: return "Hong Kong Dollar"
        case .inr: return "Indian Rupee"
        case .eur: return "Euro"
        case .chf: return "Swiss Franc"
        }
    }

    /// How many units of this currency equal 1 US Dollar.
    /// Approximate mid-market rates — edit these to update the conversion.
    var unitsPerUSD: Double {
        switch self {
        case .usd: return 1.0
        case .hkd: return 7.81
        case .inr: return 87.5
        case .eur: return 0.86
        case .chf: return 0.80
        }
    }
}
