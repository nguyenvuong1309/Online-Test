//
//  CurrencyConverter.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import SwiftUI

struct CurrencyConverter: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @EnvironmentObject var languageSettings: SettingsViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.states {
            case .finished:
                currencyConversionForm()
            case .loading:
                ProgressView("Loading")
            case .error(let error):
                CustomStateView(image: "exclamationmark.transmission",
                                description: "Something went wrong!",
                                tintColor: .red)
                .alert(isPresented: $viewModel.showError) {
                    Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("Ok"), action: {
                        viewModel.changeStateToEmpty()
                    }))
                }
            case .ready:
                ProgressView()
                    .onAppear(perform: viewModel.initializeService)
            case .empty:
                CustomStateView(image: "newspaper", description: "There is no data :(", tintColor: .indigo)
            }
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Close")))
        }
    }
    
    // MARK: - Currency Conversion Form View
    @ViewBuilder
    private func currencyConversionForm() -> some View {
        Form {
            // Input Amount Section
            Section(header: Text("Enter Amount".localised(using: languageSettings.selectedLanguage))) {
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Amount".localised(using: languageSettings.selectedLanguage), text: $viewModel.inputAmount)
                        .keyboardType(.decimalPad)
                        .padding(.vertical, 5)
                    
                    // Display error message if input is invalid
                    if !viewModel.isInputValid {
                        Text("Invalid amount entered".localised(using: languageSettings.selectedLanguage))
                            .foregroundColor(.red)
                            .font(.caption)
                            .transition(.opacity)
                    }
                }
            }
            
            // Select Currencies Section
            currencySelectionSection()
            
            // Conversion Result Section
            Section(header: Text("Result".localised(using: languageSettings.selectedLanguage))) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("\(viewModel.formattedConvertedAmount) \(viewModel.toCurrency)")
                }
            }
            
            // Settings Navigation
            Section {
                NavigationLink(destination: SettingsView()) {
                    Text("Settings".localised(using: languageSettings.selectedLanguage))
                }
            }
        }
        .navigationTitle("Currency Convert".localised(using: languageSettings.selectedLanguage))
        .toolbar {
            Button("Convert".localised(using: languageSettings.selectedLanguage)) {
                viewModel.convertCurrency()
            }
            .disabled(!viewModel.isInputValid) // Disable button if input is invalid
        }
    }
    
    // Currency Selection Section
    private func currencySelectionSection() -> some View {
        Section(header: Text("Select Currencies".localised(using: languageSettings.selectedLanguage))) {
            HStack {
                Text("From".localised(using: languageSettings.selectedLanguage))
                Spacer()
                currencyPicker(for: $viewModel.fromCurrency, presented: $viewModel.isFromCurrencyPickerPresented)
            }
            HStack {
                Text("To".localised(using: languageSettings.selectedLanguage))
                Spacer()
                currencyPicker(for: $viewModel.toCurrency, presented: $viewModel.isToCurrencyPickerPresented)
            }
        }
    }
    
    // Currency Picker Helper
    private func currencyPicker(for currency: Binding<String>, presented: Binding<Bool>) -> some View {
        Button(action: { presented.wrappedValue = true }) {
            Text("\(viewModel.currencyFlags[currency.wrappedValue] ?? "") \(currency.wrappedValue)")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: presented) {
            CurrencyPickerView(selectedCurrency: currency, currencies: viewModel.currencies, currencyFlags: viewModel.currencyFlags)
                .environmentObject(languageSettings)
        }
    }
}

struct CurrencyConverter_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverter()
            .environmentObject(SettingsViewModel())
    }
}
