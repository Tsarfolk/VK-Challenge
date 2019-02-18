import Foundation

class PostAuthor: JSONable {
    let id: Int
    let name: String
    let photo: String
    
    required init?(json: [String : Any]) {
        guard let id = json.int(key: "id"),
            let photo = json.string(key: "photo_50") else {
            return nil
        }
        if let firstName = json.string(key: "first_name"),
            let lastName = json.string(key: "last_name") {
            name = "\(firstName) \(lastName)"
        } else if let name = json.string(key: "name") {
            self.name = name
        } else {
            return nil
        }
        
        self.id = id
        self.photo = photo
    }
}
