import Foundation

final class Paginator {
    var startFrom: String?
}

extension Paginator: DictionaryConvertable {
    func toDictionary() -> [String: String] {
        guard let startFrom = startFrom else {
            return [:]
        }
        
        return ["start_from": startFrom]
    }
}
