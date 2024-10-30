import Foundation
import Combine
import SwiftUI

class CurrencyConverterViewModel: BaseViewModel<CurrencyConverterStates> {
    // Published properties
//    @Published var inputAmount: String = ""
    @Published var fromCurrency: String = "EUR"
    @Published var toCurrency: String = "USD"
    @Published var convertedAmount: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isFromCurrencyPickerPresented: Bool = false
    @Published var isToCurrencyPickerPresented: Bool = false
    @Published var inputAmount: String = "" {
        didSet {
            validateInputAmount()
        }
    }
    @Published var isInputValid: Bool = true
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("selectedLanguage") var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    @Published var exchangeRates: [String: Double] = [:]

    var showingAlert: Bool = false
    
    
    private var cancellables = Set<AnyCancellable>()
    

    let currencies = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", 
    "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYN", "BYR", "BZD", "CAD", 
    "CDF", "CHF", "CLF", "CLP", "CNY", "CNH", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", 
    "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", 
    "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", 
    "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", 
    "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", 
    "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", 
    "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", 
    "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VES", 
    "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMK", "ZMW", "ZWL"]

    let currencyFlags: [String: String] = [
    "AED": "🇦🇪", // United Arab Emirates
    "AFN": "🇦🇫", // Afghanistan
    "ALL": "🇦🇱", // Albania
    "AMD": "🇦🇲", // Armenia
    "ANG": "🇳🇱", // Curaçao & Sint Maarten (Netherlands)
    "AOA": "🇦🇴", // Angola
    "ARS": "🇦🇷", // Argentina
    "AUD": "🇦🇺", // Australia
    "AWG": "🇦🇼", // Aruba
    "AZN": "🇦🇿", // Azerbaijan
    "BAM": "🇧🇦", // Bosnia & Herzegovina
    "BBD": "🇧🇧", // Barbados
    "BDT": "🇧🇩", // Bangladesh
    "BGN": "🇧🇬", // Bulgaria
    "BHD": "🇧🇭", // Bahrain
    "BIF": "🇧🇮", // Burundi
    "BMD": "🇧🇲", // Bermuda
    "BND": "🇧🇳", // Brunei
    "BOB": "🇧🇴", // Bolivia
    "BRL": "🇧🇷", // Brazil
    "BSD": "🇧🇸", // Bahamas
    "BTC": "🟡",   // Bitcoin (No specific flag)
    "BTN": "🇧🇹", // Bhutan
    "BWP": "🇧🇼", // Botswana
    "BYN": "🇧🇾", // Belarus
    "BYR": "🇧🇾", // Belarus (Old)
    "BZD": "🇧🇿", // Belize
    "CAD": "🇨🇦", // Canada
    "CDF": "🇨🇩", // Democratic Republic of the Congo
    "CHF": "🇨🇭", // Switzerland
    "CLF": "🇨🇱", // Chile (Unidad de Fomento)
    "CLP": "🇨🇱", // Chile
    "CNY": "🇨🇳", // China
    "CNH": "🇨🇳", // China (Offshore)
    "COP": "🇨🇴", // Colombia
    "CRC": "🇨🇷", // Costa Rica
    "CUC": "🇨🇺", // Cuba (Convertible Peso)
    "CUP": "🇨🇺", // Cuba
    "CVE": "🇨🇻", // Cape Verde
    "CZK": "🇨🇿", // Czech Republic
    "DJF": "🇩🇯", // Djibouti
    "DKK": "🇩🇰", // Denmark
    "DOP": "🇩🇴", // Dominican Republic
    "DZD": "🇩🇿", // Algeria
    "EGP": "🇪🇬", // Egypt
    "ERN": "🇪🇷", // Eritrea
    "ETB": "🇪🇹", // Ethiopia
    "EUR": "🇪🇺", // Eurozone
    "FJD": "🇫🇯", // Fiji
    "FKP": "🇫🇰", // Falkland Islands
    "GBP": "🇬🇧", // United Kingdom
    "GEL": "🇬🇪", // Georgia
    "GGP": "🇬🇬", // Guernsey
    "GHS": "🇬🇭", // Ghana
    "GIP": "🇬🇮", // Gibraltar
    "GMD": "🇬🇲", // Gambia
    "GNF": "🇬🇳", // Guinea
    "GTQ": "🇬🇹", // Guatemala
    "GYD": "🇬🇾", // Guyana
    "HKD": "🇭🇰", // Hong Kong
    "HNL": "🇭🇳", // Honduras
    "HRK": "🇭🇷", // Croatia
    "HTG": "🇭🇹", // Haiti
    "HUF": "🇭🇺", // Hungary
    "IDR": "🇮🇩", // Indonesia
    "ILS": "🇮🇱", // Israel
    "IMP": "🇮🇲", // Isle of Man
    "INR": "🇮🇳", // India
    "IQD": "🇮🇶", // Iraq
    "IRR": "🇮🇷", // Iran
    "ISK": "🇮🇸", // Iceland
    "JEP": "🇯🇪", // Jersey
    "JMD": "🇯🇲", // Jamaica
    "JOD": "🇯🇴", // Jordan
    "JPY": "🇯🇵", // Japan
    "KES": "🇰🇪", // Kenya
    "KGS": "🇰🇬", // Kyrgyzstan
    "KHR": "🇰🇭", // Cambodia
    "KMF": "🇰🇲", // Comoros
    "KPW": "🇰🇵", // North Korea
    "KRW": "🇰🇷", // South Korea
    "KWD": "🇰🇼", // Kuwait
    "KYD": "🇰🇾", // Cayman Islands
    "KZT": "🇰🇿", // Kazakhstan
    "LAK": "🇱🇦", // Laos
    "LBP": "🇱🇧", // Lebanon
    "LKR": "🇱🇰", // Sri Lanka
    "LRD": "🇱🇷", // Liberia
    "LSL": "🇱🇸", // Lesotho
    "LTL": "🇱🇹", // Lithuania (Old)
    "LVL": "🇱🇻", // Latvia (Old)
    "LYD": "🇱🇾", // Libya
    "MAD": "🇲🇦", // Morocco
    "MDL": "🇲🇩", // Moldova
    "MGA": "🇲🇬", // Madagascar
    "MKD": "🇲🇰", // North Macedonia
    "MMK": "🇲🇲", // Myanmar
    "MNT": "🇲🇳", // Mongolia
    "MOP": "🇲🇴", // Macau
    "MRU": "🇲🇷", // Mauritania
    "MUR": "🇲🇺", // Mauritius
    "MVR": "🇲🇻", // Maldives
    "MWK": "🇲🇼", // Malawi
    "MXN": "🇲🇽", // Mexico
    "MYR": "🇲🇾", // Malaysia
    "MZN": "🇲🇿", // Mozambique
    "NAD": "🇳🇦", // Namibia
    "NGN": "🇳🇬", // Nigeria
    "NIO": "🇳🇮", // Nicaragua
    "NOK": "🇳🇴", // Norway
    "NPR": "🇳🇵", // Nepal
    "NZD": "🇳🇿", // New Zealand
    "OMR": "🇴🇲", // Oman
    "PAB": "🇵🇦", // Panama
    "PEN": "🇵🇪", // Peru
    "PGK": "🇵🇬", // Papua New Guinea
    "PHP": "🇵🇭", // Philippines
    "PKR": "🇵🇰", // Pakistan
    "PLN": "🇵🇱", // Poland
    "PYG": "🇵🇾", // Paraguay
    "QAR": "🇶🇦", // Qatar
    "RON": "🇷🇴", // Romania
    "RSD": "🇷🇸", // Serbia
    "RUB": "🇷🇺", // Russia
    "RWF": "🇷🇼", // Rwanda
    "SAR": "🇸🇦", // Saudi Arabia
    "SBD": "🇸🇧", // Solomon Islands
    "SCR": "🇸🇨", // Seychelles
    "SDG": "🇸🇩", // Sudan
    "SEK": "🇸🇪", // Sweden
    "SGD": "🇸🇬", // Singapore
    "SHP": "🇸🇭", // Saint Helena
    "SLE": "🇸🇱", // Sierra Leone
    "SLL": "🇸🇱", // Sierra Leone (Old)
    "SOS": "🇸🇴", // Somalia
    "SRD": "🇸🇷", // Suriname
    "STD": "🇸🇹", // São Tomé & Príncipe (Old)
    "SVC": "🇸🇻", // El Salvador
    "SYP": "🇸🇾", // Syria
    "SZL": "🇸🇿", // Eswatini
    "THB": "🇹🇭", // Thailand
    "TJS": "🇹🇯", // Tajikistan
    "TMT": "🇹🇲", // Turkmenistan
    "TND": "🇹🇳", // Tunisia
    "TOP": "🇹🇴", // Tonga
    "TRY": "🇹🇷", // Turkey
    "TTD": "🇹🇹", // Trinidad & Tobago
    "TWD": "🇹🇼", // Taiwan
    "TZS": "🇹🇿", // Tanzania
    "UAH": "🇺🇦", // Ukraine
    "UGX": "🇺🇬", // Uganda
    "USD": "🇺🇸", // United States
    "UYU": "🇺🇾", // Uruguay
    "UZS": "🇺🇿", // Uzbekistan
    "VEF": "🇻🇪", // Venezuela (Old)
    "VES": "🇻🇪", // Venezuela
    "VND": "🇻🇳", // Vietnam
    "VUV": "🇻🇺", // Vanuatu
    "WST": "🇼🇸", // Samoa
    "XAF": "🌍", // Central African CFA Franc (No specific emoji)
    "XAG": "🟡", // Silver (Commodity)
    "XAU": "🟡", // Gold (Commodity)
    "XCD": "🇨🇩", // East Caribbean Dollar (Caribbean nations)
    "XDR": "🌐", // Special Drawing Rights (No emoji)
    "XOF": "🌍", // West African CFA Franc (No specific emoji)
    "XPF": "🌐", // CFP Franc (No specific emoji)
    "YER": "🇾🇪", // Yemen
    "ZAR": "🇿🇦", // South Africa
    "ZMK": "🇿🇲", // Zambia (Old)
    "ZMW": "🇿🇲", // Zambia
    "ZWL": "🇿🇼", // Zimbabwe
]

    // Input validation method
    func validateInputAmount() {
        if let _ = Double(inputAmount), !inputAmount.isEmpty {
            isInputValid = true
        } else {
            isInputValid = false
        }
    }

    // Initialize the service and fetch exchange rates
    func initializeService() {
        fetchExchangeRates { [weak self] success in
            guard let self = self else { return }
            self.isLoading = false
            self.changeState(.finished)
            if !success {
                self.errorMessage = NSLocalizedString("cannot_fetch_exchange_rates", comment: "")
                self.showError = true
            }
        }
    }

    func changeStateToEmpty() {
        changeState(.empty)
    }
    
    // Function to perform currency conversion
    func convertCurrency() {
        guard let amount = Double(inputAmount), amount > 0 else {
            errorMessage = NSLocalizedString("invalid_amount", comment: "")
            showError = true
            return
        }
        isLoading = true
        fetchExchangeRates { [weak self] success in
            guard let self = self else { return }
            self.isLoading = false
            if success, let fromRate = self.exchangeRates[self.fromCurrency], let toRate = self.exchangeRates[self.toCurrency] {
                self.convertedAmount = (amount / fromRate) * toRate
            } else {
                self.errorMessage = NSLocalizedString("cannot_fetch_exchange_rates", comment: "")
                self.showError = true
            }
        }
    }
    
    // Fetch exchange rates with enhanced error handling
    private func fetchExchangeRates(completion: @escaping (Bool) -> Void) {
        let urlString = "https://api.exchangeratesapi.io/v1/latest?access_key=6c2b4fca77673f4bd910d44f419efa3f"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                let decoder = JSONDecoder()
                return try decoder.decode(ExchangeRatesResponse.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    self.showError = true
                    self.errorMessage = "Failed to fetch rates: \(error.localizedDescription)"
                    completion(false)
                }
            }, receiveValue: { [weak self] exchangeData in
                guard let self = self else { return }
                self.exchangeRates = exchangeData.rates
                self.exchangeRates[exchangeData.base] = 1.0
                completion(true)
            })
            .store(in: &cancellables)
    }
    
    // Helper to format the converted amount
    var formattedConvertedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: convertedAmount)) ?? "0.00"
    }
}
