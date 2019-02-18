import Foundation

enum LocalizableKeys: String {
    case seconds
    case minutes
    case hours
    case posts
    
    static func localized(key: LocalizableKeys, with number: Int) -> String {
        let format = NSLocalizedString(key.rawValue, comment: "")
        let locale = Locale(identifier: Bundle.main.preferredLocalizations.first ?? "Ru-ru")
        return String(format: format, locale: locale, number)
    }
}
