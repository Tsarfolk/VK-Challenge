import Foundation

final class ServerPostList: JSONable {
    let posts: [ServerPost]
    let nextFrom: String
    
    required init?(json: [String : Any]) {
        guard let responseJSON = json.json(key: "response") else { return nil }
        guard let nextFrom = responseJSON.string(key: "next_from"),
            let items = responseJSON.array(key: "items") else {
                return nil
        }
        
        let users = (responseJSON.arrayValue(key: "profiles") + responseJSON.arrayValue(key: "groups"))
            .compactMap { PostAuthor(json: $0) }
        
        let postIds = NSMutableSet()
        posts = items
            .compactMap({ (json) -> ServerPost? in
                guard let post = ServerPost(json: json), !postIds.contains(post.postId) else { return nil }
                postIds.add(post.postId)
                if let author = users.first(where: { abs($0.id) == abs(post.sourceId) }) {
                    post.author = author
                    return post
                } else {
                    return nil
                }
            })
        
        self.nextFrom = nextFrom
    }
}
