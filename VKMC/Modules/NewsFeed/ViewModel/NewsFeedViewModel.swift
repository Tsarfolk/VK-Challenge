import Foundation

class NewsFeedViewModel {
    var userLoaded: ((User) -> Void)?
    var stateChanged: ((NewsFeedViewModelState) -> Void)?
    var postsUpdated: (() -> Void)?
    var clearCache: (() -> Void)?
    
    private(set) var posts: [Post] = [] {
        didSet {
            postsUpdated?()
        }
    }
    private(set) var user: User? {
        didSet {
            guard let user = user else { return }
            userLoaded?(user)
        }
    }
    
    private let serverAPI: ServerAPI
    private var paginator = Paginator()
    private var previousSearch: String?
    private(set) var currentSearch: String?
    var isSearchActive: Bool { return currentSearch != nil }
    
    init(serverAPI: ServerAPI) {
        self.serverAPI = serverAPI
    }
    
    private(set) var state: NewsFeedViewModelState = .loading {
        didSet {
            stateChanged?(state)
        }
    }
    private var feedNextPageIsLoading: Bool = false
    private var searchNextPageIsLoading: Bool = false
    
    func loadUser() {
        serverAPI.getUserInfo { [weak self] (result) in
            guard let sSelf = self else { return }
            switch result {
            case .success(let serverUser):
                let loadedUser = User(serverUser: serverUser)
                DispatchQueue.main.async { sSelf.user = loadedUser }
            case .fail:
                // ignoring error
                break
            }
        }
    }
    
    func loadNextPageForSearch() {
        guard let previousSearch = previousSearch else { return }
        search(text: previousSearch, isNewSearch: false)
    }
    
    func search(text: String, isNewSearch: Bool = true) {
        guard !searchNextPageIsLoading else { return }
        searchNextPageIsLoading = true
        // TODO: cancel prev search
        // TODO: sync feed & search
        if isNewSearch {
            paginator = Paginator()
            posts = []
        }
        currentSearch = text
        state = .loading
        serverAPI.searchFeed(paginator: paginator, search: text) { [weak self] (result) in
            guard let sSelf = self else { return }
            defer {
                DispatchQueue.main.async {
                    sSelf.state = .normal(postCount: sSelf.posts.count)
                    sSelf.searchNextPageIsLoading = false
                    sSelf.previousSearch = text
                }
            }
            guard !sSelf.feedNextPageIsLoading else { return }
            switch result {
            case .success(let postsModel):
                sSelf.paginator.startFrom = postsModel.nextFrom
                let loadedPosts = postsModel.posts.compactMap { Post(serverModel: $0) }
                DispatchQueue.main.async {
                    if isNewSearch {
                        sSelf.clearCache?()
                        sSelf.posts = loadedPosts
                    } else {
                        sSelf.posts += loadedPosts
                    }
                }
            case .fail:
                // ignoring error
                break
            }
        }
    }
    
    func reload() {
        loadFeed(isReloading: true)
    }
    
    func clearSearch() {
        posts = []
        clearCache?()
        previousSearch = nil
        currentSearch = nil
        loadFeed()
    }
    
    func loadFeed(isReloading: Bool = false) {
        guard !feedNextPageIsLoading else { return }
        feedNextPageIsLoading = true
        state = .loading
        serverAPI.newsFeed(paginator: paginator) { [weak self] (result) in
            guard let sSelf = self else { return }
            defer {
                DispatchQueue.main.async {
                    sSelf.state = .normal(postCount: sSelf.posts.count)
                    sSelf.feedNextPageIsLoading = false
                }
            }
            
            switch result {
            case .success(let postsModel):
                sSelf.paginator.startFrom = postsModel.nextFrom
                let loadedPosts = postsModel.posts.compactMap { Post(serverModel: $0) }
                DispatchQueue.main.async {
                    if isReloading {
                        sSelf.clearCache?()
                        sSelf.posts = loadedPosts
                    } else {
                        sSelf.posts += loadedPosts
                    }
                }
            case .fail:
                // ignoring error
                break
            }
        }
    }
}
