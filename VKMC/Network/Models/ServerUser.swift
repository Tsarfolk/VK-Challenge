import Foundation

final class ServerUser: JSONable {
    let id: Int
    let photo: String
    let firstName: String
    let lastName: String
    
    required init?(json: [String : Any]) {
        guard let userJSON = json.arrayValue(key: "response").first else {
            return nil
        }
        guard let id = userJSON.int(key: "id"),
            let photo = userJSON.string(key: "photo"),
            let firstName = userJSON.string(key: "first_name"),
            let lastName = userJSON.string(key: "last_name") else {
                return nil
        }
        
        self.id = id
        self.photo = photo
        self.firstName = firstName
        self.lastName = lastName
    }
}
