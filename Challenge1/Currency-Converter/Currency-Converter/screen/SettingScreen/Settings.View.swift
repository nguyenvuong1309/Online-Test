// SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var languageSettings: SettingsViewModel
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    var body: some View {
        Form {
            // Phần chọn ngôn ngữ
            Section(header: Text("language".localised(using: languageSettings.selectedLanguage))) {
                NavigationLink(destination: LanguageSelectionView()) {
                    HStack {
                        Text("select_language".localised(using: languageSettings.selectedLanguage))
                        Spacer()
                        if let language = Language.supportedLanguages.first(where: { $0.code == languageSettings.selectedLanguage }) {
                            HStack {
                                Text(language.flag)
                                Text(language.name)
                            }
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            // Phần chọn giao diện (sáng/tối)
            Section(header: Text("appearance".localised(using: languageSettings.selectedLanguage))) {
                Toggle(isOn: $isDarkMode) {
                    Text("dark_mode".localised(using: languageSettings.selectedLanguage))
                }
            }
        }
        .navigationTitle("settings".localised(using: languageSettings.selectedLanguage))
    }
}
