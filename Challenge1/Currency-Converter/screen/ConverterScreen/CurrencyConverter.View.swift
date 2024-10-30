import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @EnvironmentObject var languageSettings: SettingsViewModel

    @State private var isFromCurrencyPickerPresented = false
    @State private var isToCurrencyPickerPresented = false

    var body: some View {
        NavigationView {
            Form {
                // Input Amount Section
                Section(header: Text("enter_amount".localised(using: languageSettings.selectedLanguage))) {
                    VStack(alignment: .leading) {
                        TextField("amount".localised(using: languageSettings.selectedLanguage), text: $viewModel.inputAmount)
                            .keyboardType(.decimalPad)
                        
                        if let error = viewModel.inputAmountError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }

                // Select Currencies Section
                Section(header: Text("select_currencies".localised(using: languageSettings.selectedLanguage))) {
                    HStack {
                        Text("from".localised(using: languageSettings.selectedLanguage))
                        Spacer()
                        Button(action: {
                            isFromCurrencyPickerPresented = true
                        }) {
                            Text("\(viewModel.currencyFlags[viewModel.fromCurrency] ?? "") \(viewModel.fromCurrency)")
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $isFromCurrencyPickerPresented) {
                            CurrencyPickerView(
                                selectedCurrency: $viewModel.fromCurrency,
                                currencies: viewModel.currencies,
                                currencyFlags: viewModel.currencyFlags
                            )
                            .environmentObject(languageSettings)
                        }
                    }
                    HStack {
                        Text("to".localised(using: languageSettings.selectedLanguage))
                        Spacer()
                        Button(action: {
                            isToCurrencyPickerPresented = true
                        }) {
                            Text("\(viewModel.currencyFlags[viewModel.toCurrency] ?? "") \(viewModel.toCurrency)")
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $isToCurrencyPickerPresented) {
                            CurrencyPickerView(
                                selectedCurrency: $viewModel.toCurrency,
                                currencies: viewModel.currencies,
                                currencyFlags: viewModel.currencyFlags
                            )
                            .environmentObject(languageSettings)
                        }
                    }
                }

                // Result Section
                Section(header: Text("result".localised(using: languageSettings.selectedLanguage))) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("\(viewModel.formattedConvertedAmount)")
                    }
                }

                // Settings Navigation
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Text("settings".localised(using: languageSettings.selectedLanguage))
                    }
                }
            }
            .navigationTitle("currency_convert".localised(using: languageSettings.selectedLanguage))
            .toolbar {
                Button("convert".localised(using: languageSettings.selectedLanguage)) {
                    viewModel.convertCurrency()
                }
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("error".localised(using: languageSettings.selectedLanguage)),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("close".localised(using: languageSettings.selectedLanguage)))
                )
            }
            .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        }
        .onAppear {
            viewModel.serviceInitialize()
        }
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
            .environmentObject(SettingsViewModel())
    }
}
