import Foundation

class ServerAPI {
    private let urlSession = URLSession.shared
    private let baseUrl = "https://api.vk.com/method/"
    private let queryUrlMaker: QueryUrlMaker
    
    enum Method: String {
        case usersGet = "users.get"
        case newsfeedSearch = "newsfeed.search"
        case newsfeedGet = "newsfeed.get"
    }
    
    enum Result<Type> {
        case success(value: Type)
        case fail
    }
    
    var searchTask: URLSessionTask?
    
    private let accessToken: String
    init(accessToken: String) {
        self.accessToken = accessToken
        self.queryUrlMaker = QueryUrlMaker()
    }
    
    func getUserInfo(completion: @escaping (Result<ServerUser>) -> Void) {
        let params = [
            "fields": "photo"
        ]
        mappedRequest(with: .usersGet, params: params, callBack: completion)
    }
    
    func searchFeed(paginator: Paginator, search: String, completion: @escaping (Result<ServerPostList>) -> Void) {
        var params: [String: String] = [
            "extended": "1",
            "count": "30",
            "q": search
        ]
        
        params.merge(paginator.toDictionary(), uniquingKeysWith: { lhs, rhs in return lhs })
        searchTask = mappedRequest(with: .newsfeedSearch, params: params, callBack: completion)
    }
    
    func newsFeed(paginator: Paginator, completion: @escaping (Result<ServerPostList>) -> Void) {
        var params: [String: String] = [
            "extended": "1",
            "count": "30"
        ]
        
        params.merge(paginator.toDictionary(), uniquingKeysWith: { lhs, rhs in return lhs })
        mappedRequest(with: .newsfeedGet, params: params, callBack: completion)
    }
    
    @discardableResult
    private func mappedRequest<Model: JSONable>(with method: Method, params: [String: String], callBack: @escaping (Result<Model>) -> Void) -> URLSessionTask? {
        return jsonParsedRequest(with: method, params: params) { (result) in
            switch result {
            case .success(let json):
                guard let model = Model(json: json) else {
                    logger.log(type: .error, message: "Error on model parsing")
                    callBack(.fail)
                    return
                }
                
                callBack(.success(value: model))
            case .fail:
                callBack(.fail)
            }
        }
    }
    
    private func jsonParsedRequest(with method: Method, params: [String: String], callBack: @escaping (Result<[String: Any]>) -> Void) -> URLSessionTask? {
        return makeRequest(with: method, params: params) { (result) in
            switch result {
            case .success(let data):
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:] else {
                    logger.log(type: .error, message: "Error on json parsing")
                    callBack(.fail)
                    return
                }
                
                callBack(.success(value: json))
            case .fail:
                callBack(.fail)
            }
        }
    }
    
    private func makeRequest(with method: Method, params: [String: String], callBack: @escaping (Result<Data>) -> Void) -> URLSessionTask? {
        var requestParams = params
        requestParams["access_token"] = accessToken
        requestParams["v"] = "5.87"
        
        guard let url = queryUrlMaker.createQueriedUrl(from: baseUrl + method.rawValue, and: requestParams) else { return nil }
        let request = URLRequest(url: url)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response {
                logger.log(type: .info, message: response.description)
            }
            
            if let error = error {
                logger.log(type: .error, message: error.localizedDescription)
                callBack(.fail)
            } else if let data = data {
                callBack(.success(value: data))
            } else {
                logger.log(type: .error, message: "Data is empty")
                callBack(.fail)
            }
        }
        task.resume()
        
        return task
    }
}
