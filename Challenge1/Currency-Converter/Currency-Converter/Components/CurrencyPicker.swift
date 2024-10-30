import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageSettings: SettingsViewModel
    @Binding var selectedCurrency: String
    @State private var searchText = ""
    
    let currencies: [String]
    let currencyFlags: [String: String]
    
    var filteredCurrencies: [String] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCurrencies, id: \.self) { currency in
                    Button(action: {
                        selectedCurrency = currency
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text("\(currencyFlags[currency] ?? "") \(currency)")
                            if currency == selectedCurrency {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: NSLocalizedString("select_currencies", comment: ""))
            .navigationTitle(NSLocalizedString("select_currencies", comment: ""))
            .navigationBarItems(trailing: Button(NSLocalizedString("close", comment: "")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}