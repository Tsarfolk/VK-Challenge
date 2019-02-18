import Foundation

class QueryUrlMaker {
    func createQueriedUrl(from baseUrl: String, and params: [String: String]) -> URL? {
        guard var component = URLComponents(string: baseUrl) else { return nil }
        component.queryItems = params.map({ (elem) -> URLQueryItem in
            let (key, value) = elem
            return URLQueryItem(name: key, value: value)
        })
        return component.url
    }
}
