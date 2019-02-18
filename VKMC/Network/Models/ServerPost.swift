import Foundation

class ServerPost: JSONable {
    let photos: [ServerPhoto]
    var author: PostAuthor?
    let text: String
    let date: Int
    let likes: Int
    let reposts: Int
    let views: Int
    let comments: Int
    let sourceId: Int
    let postId: Int
    
    required init?(json: [String : Any]) {
        guard let postId = json.int(key: "post_id") ?? json.int(key: "id"),
            let sourceId = json.int(key: "source_id") ?? json.int(key: "owner_id"),
            let text = json.string(key: "text"),
            let date = json.int(key: "date"),
            let likes = json.jsonValue(key: "likes").int(key: "count"),
            let reposts = json.jsonValue(key: "reposts").int(key: "count"),
            let comments = json.jsonValue(key: "comments").int(key: "count")
            else {
                return nil
        }
        
        self.postId = postId
        self.sourceId = sourceId
        self.photos = json.arrayValue(key: "attachments")
            .lazy
            .filter { $0["type"] as? String == "photo" }
            .compactMap { $0.json(key: "photo") }
            .compactMap { ServerPhoto(json: $0) }
        if self.photos.isEmpty, text.isEmpty {
            return nil
        }
        self.text = text
        self.date = date
        self.likes = likes
        self.reposts = reposts
        self.views = json.jsonValue(key: "views").intValue(key: "count")
        self.comments = comments
    }
}
