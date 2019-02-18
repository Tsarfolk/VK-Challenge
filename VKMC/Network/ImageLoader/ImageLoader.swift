import Foundation

class ImageLoader {
    // urls -> requests
    var requests: [String: RequestInfo] = [:]
    
    static let shared = ImageLoader()
    
    private let cache = ImageCache()
    private let session = URLSession.shared
    
    private let syncDispatchQueue = DispatchQueue(label: "ios.vkmc.imageloadsyncqueue")
    
    class RequestInfo {
        let request: URLSessionDataTask
        var completion: ((Data) -> Void)?
        
        init(request: URLSessionDataTask, completion: ((Data) -> Void)?) {
            self.request = request
            self.completion = completion
        }
        
        func suspend() {
            request.suspend()
        }
        
        func resume() {
            request.resume()
        }
    }
    
    func loadImage(urlString: String, completion: @escaping (Data) -> Void) {
        if let data = cache.hit(at: urlString) {
            completion(data)
            return
        }
        syncDispatchQueue.async {
            guard let url = URL(string: urlString) else { return }
            if let request = self.requests[urlString] {
                request.completion = completion
                request.resume()
                return
            }
            
            let request = self.session.dataTask(with: url) { (data, response, error) in
                self.syncDispatchQueue.async {
                    defer { self.requests[urlString] = nil }
                    guard let data = data else {
                        return
                    }
                    self.cache.put(data: data, at: urlString)
                    self.requests[urlString]?.completion?(data)
                }
            }
            self.requests[urlString] = RequestInfo(request: request, completion: completion)
            request.resume()
        }
    }
    
    func suspend(at url: String) {
        requests[url]?.suspend()
    }
    
    func suspend(urls: [String]) {
        urls.forEach { suspend(at: $0) }
    }
}
