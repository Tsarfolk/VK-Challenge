import Foundation

enum LocalizedString: String {
    case ago
    case yesterday
    case at
    case expandText = "expand_text"
    case search
    
    static func localized(key: LocalizedString) -> String {
        return NSLocalizedString(key.rawValue, comment: "")
    }
}
