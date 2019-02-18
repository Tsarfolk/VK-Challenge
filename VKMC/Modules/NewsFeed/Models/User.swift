import Foundation

struct User {
    let photoUrl: String
    
    init(serverUser: ServerUser) {
        photoUrl = serverUser.photo
    }
}
