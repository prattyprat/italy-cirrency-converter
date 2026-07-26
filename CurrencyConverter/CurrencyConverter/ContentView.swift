import SwiftUI

struct ContentView: View {
    @StateObject private var model = ConverterModel()
    @FocusState private var focusedField: Currency?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(Currency.allCases) { currency in
                        CurrencyBox(
                            currency: currency,
                            text: Binding(
                                get: { model.amounts[currency] ?? "" },
                                set: { model.update(currency, to: $0) }
                            ),
                            isFocused: focusedField == currency
                        )
                        .focused($focusedField, equals: currency)
                    }

                    Text("Rates are approximate and fixed in the app. Update Currency.swift to refresh them.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Currency Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
        }
    }
}

private struct CurrencyBox: View {
    let currency: Currency
    @Binding var text: String
    var isFocused: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(currency.rawValue)
                    .font(.headline)
                Text(currency.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 4) {
                Text(currency.symbol)
                    .font(.title3)
                    .foregroundColor(.secondary)
                TextField("0", text: $text)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.title2.weight(.semibold))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    ContentView()
}
