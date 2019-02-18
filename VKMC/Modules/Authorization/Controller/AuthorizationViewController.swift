import UIKit
import VK_ios_sdk

class AuthorizationViewController: UIViewController {
    private let viewModel: AuthorizationViewModel
    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = VKMCColors.lightGrey
        
        viewModel.setUIDelegate(delegate: self)
        viewModel.startAuthorization()
    }
}

extension AuthorizationViewController: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) { }
}
