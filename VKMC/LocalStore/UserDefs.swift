import Foundation

protocol UserLocalStore {
    var accessToken: String? { get }
    func saveAccessToken(_ token: String)
}

class UserDefs {
    // for the sake of simlicity, better in keychain
    enum Keys: String {
        case accessToken
    }
    
    private let defaults = UserDefaults.standard
}

extension UserDefs: UserLocalStore {
    var accessToken: String? {
        return defaults.string(forKey: Keys.accessToken.rawValue)
    }
    
    func saveAccessToken(_ token: String) {
        defaults.set(token, forKey: Keys.accessToken.rawValue)
    }
}
