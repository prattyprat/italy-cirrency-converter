import SwiftUI

struct ContentView: View {
    @StateObject private var model = ConverterModel()
    @FocusState private var focusedField: Currency?
    @State private var previouslyFocusedField: Currency?

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

                    Button(role: .destructive) {
                        focusedField = nil
                        model.clearAll()
                    } label: {
                        Text("Clear All")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)

                    Text("Boxes accept basic math (e.g. 12+3*2). Rates are approximate and fixed in the app — update Currency.swift to refresh them.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Currency Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("=") {
                        if let field = focusedField {
                            model.commit(field)
                        }
                    }
                    Button("Done") { focusedField = nil }
                }
            }
            .onChange(of: focusedField) { newValue in
                if let previous = previouslyFocusedField, previous != newValue {
                    model.commit(previous)
                }
                previouslyFocusedField = newValue
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
