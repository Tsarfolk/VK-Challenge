import Foundation
import VK_ios_sdk

class AuthorizationViewModel: NSObject {
    var authorized: ((String) -> Void)?
    
    private let vkInstance: VKSdk
    init(vkInstance: VKSdk) {
        self.vkInstance = vkInstance
    }

    func startAuthorization() {
        vkInstance.register(self)
        let authParams = ["wall", "friends"]
        VKSdk.authorize(authParams)
    }
    
    func setUIDelegate(delegate: VKSdkUIDelegate) {
        vkInstance.uiDelegate = delegate
    }
}

extension AuthorizationViewModel: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        guard let token = result.token.accessToken else { return }
        authorized?(token)
    }
    
    func vkSdkUserAuthorizationFailed() {
    }
}
