import Foundation

final class ServerPhotoSize: JSONable {
    let url: String
    let type: String
    let width: Int
    let height: Int
    
    init?(json: [String : Any]) {
        guard let url = json.string(key: "url"),
            let type = json.string(key: "type"),
            let width = json.int(key: "width"),
            let height = json.int(key: "height") else {
            return nil
        }
        
        self.url = url
        self.type = type
        self.height = height
        self.width = width
    }
}
