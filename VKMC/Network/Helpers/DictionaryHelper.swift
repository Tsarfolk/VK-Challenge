import Foundation

extension Dictionary where Key == String, Value == Any {
    func string(key: String) -> String? {
        return self[key] as? String
    }
    
    func notEmptyString(key: String) -> String? {
        if let string = self[key] as? String, !string.isEmpty {
            return string
        } else {
            return nil
        }
    }
    
    func stringValue(key: String, defaultValue: String = "") -> String {
        return (self[key] as? String) ?? defaultValue
    }
    
    func int(key: String) -> Int? {
        return self[key] as? Int
    }
    
    func intValue(key: String, defaultValue: Int = 0) -> Int {
        return (self[key] as? Int) ?? defaultValue
    }
    
    func array(key: String) -> [[String: Any]]? {
        return self[key] as? [[String: Any]]
    }
    
    func arrayValue(key: String, defaultValue: [[String: Any]] = []) -> [[String: Any]] {
        return (self[key] as? [[String: Any]]) ?? defaultValue
    }
    
    func json(key: String) -> [String: Any]? {
        return self[key] as? [String: Any]
    }
    
    func jsonValue(key: String, defaultValue: [String: Any] = [:]) -> [String: Any] {
        return (self[key] as? [String: Any]) ?? defaultValue
    }
}
