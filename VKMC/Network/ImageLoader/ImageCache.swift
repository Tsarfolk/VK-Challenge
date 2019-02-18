import Foundation

class ImageCache {
    // implement cache reducing on the less hitted string (mem warning / image limit)
    private var storage: [String: Data] = [:]
    
    func put(data: Data, at key: String) {
        storage[key] = data
    }
    
    func hit(at key: String) -> Data? {
        return storage[key]
    }
}
