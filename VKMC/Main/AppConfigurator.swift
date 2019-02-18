import Foundation
import VK_ios_sdk

let logger = Logger()

class AppConfigurator {
    let vkInstance: VKSdk
    
    static let shared = AppConfigurator()
    
    private let vkAppId: String = "6746215"
    
    init() {
        vkInstance = VKSdk.initialize(withAppId: vkAppId)
    }
    
    func start() {
        // Put SDK config here
    }
}
