// LanguageSelectionView.swift
import SwiftUI

struct LanguageSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingViewModel: SettingsViewModel
    @State private var searchText: String = ""
    
    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return Language.supportedLanguages
        } else {
            return Language.supportedLanguages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredLanguages) { language in
                Button(action: {
                    settingViewModel.setLanguage(language.code)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(language.flag)
                        Text(language.name)
                        Spacer()
                        if language.code == settingViewModel.selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: NSLocalizedString("search_language", comment: ""))
        .navigationTitle("select_language".localised(using: settingViewModel.selectedLanguage))
    }
}


