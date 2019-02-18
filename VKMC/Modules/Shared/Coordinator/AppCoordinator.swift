import UIKit
import VK_ios_sdk

class AppCoordinator {
    private var serverAPI: ServerAPI?
    
    private let window: UIWindow
    private let userLocalStore: UserLocalStore
    init(window: UIWindow, userLocalStore: UserLocalStore) {
        self.window = window
        self.userLocalStore = userLocalStore
    }
    
    func presentRootScreen() {
        if let accessToken = userLocalStore.accessToken {
            serverAPI = ServerAPI(accessToken: accessToken)
            setRootNewsFeed()
        } else {
            setRootAuthorize()
        }
    }
    
    private func setRootAuthorize() {
        let viewModel = AuthorizationViewModel(vkInstance: VKSdk.instance())
        let controller = AuthorizationViewController(viewModel: viewModel)
        viewModel.authorized = { accessToken in
            self.userLocalStore.saveAccessToken(accessToken)
            self.serverAPI = ServerAPI(accessToken: accessToken)
            self.setRootNewsFeed()
        }
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    private func setRootNewsFeed() {
        guard let serverAPI = serverAPI else {
            return
        }
        
        let viewModel = NewsFeedViewModel(serverAPI: serverAPI)
        let controller = NewsFeedViewController(viewModel: viewModel)
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
