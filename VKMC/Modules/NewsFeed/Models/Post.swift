import Foundation

struct Post {
    let authorPhotoUrlString: String
    let authorFullName: String
    let dateDescription: String
    let text: String
    var photoUrlStrings: [String]
    let likeDescription: String
    let commentsDescription: String
    let repostsDescription: String
    let viewsDescription: String
    
    var allPhotoUrls: [String] {
        return photoUrlStrings + [authorPhotoUrlString]
    }
    
    init?(serverModel: ServerPost) {
        guard let author = serverModel.author else { return nil }
        authorPhotoUrlString = author.photo
        authorFullName = author.name
        dateDescription = Date(timeIntervalSince1970: TimeInterval(serverModel.date)).timeDisplay()
        text = serverModel.text
        
        var filteredImages: [String] = []
        serverModel.photos.forEach { (serverPhoto) in
            guard let photo = serverPhoto.sizes.first(where: { $0.type == "q" }) else {
                return
            }
            
            filteredImages.append(photo.url)
        }
        photoUrlStrings = filteredImages
        likeDescription = "\(serverModel.likes)"
        commentsDescription = "\(serverModel.comments)"
        repostsDescription = "\(serverModel.reposts)"
        viewsDescription = "\(serverModel.views)"
        
    }
}
