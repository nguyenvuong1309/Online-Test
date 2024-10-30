import Foundation

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    @Published var selectedLanguage = Locale.current.language.languageCode?.identifier ?? "en"

    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            UserDefaults.standard.set([languageCode], forKey: "MyLanguages")
            selectedLanguage = languageCode
        }
    }

    var supportedLanguages: [String] {
        return ["en", "vi"]
    }

    func languageDisplayName(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return "English"
        case "vi":
            return "Viewnamese"
        default:
            return ""
        }
    }
}
