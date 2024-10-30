//
//  Currency_ConverterApp.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @StateObject var languageSettings = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            CurrencyConverterView()
                .environmentObject(languageSettings)
        }
    }
}
