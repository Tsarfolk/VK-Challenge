import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator!
    private lazy var configurator = AppConfigurator()
}

extension AppDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configurator
        configurator.start()
        
        // Coordinator, window initialization
        let strongWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = strongWindow
        coordinator = AppCoordinator(window: strongWindow, userLocalStore: UserDefs())
        coordinator.presentRootScreen()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }
}
