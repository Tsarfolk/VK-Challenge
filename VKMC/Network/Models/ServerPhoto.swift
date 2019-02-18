import Foundation

final class ServerPhoto: JSONable {
    let id: Int
    let sizes: [ServerPhotoSize]
    
    required init?(json: [String : Any]) {
        guard let id = json.int(key: "id"),
            let sizes = json.array(key: "sizes") else {
            return nil
        }
        
        self.id = id
        self.sizes = sizes.compactMap { ServerPhotoSize(json: $0) }
    }
}
