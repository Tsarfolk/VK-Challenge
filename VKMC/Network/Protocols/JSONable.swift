import Foundation

protocol JSONable {
    init?(json: [String: Any])
}
