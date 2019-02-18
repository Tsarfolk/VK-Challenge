import UIKit

enum Assets: String {
    case cardWithShadow
    case commentOutline = "Comment_outline_24"
    case likeOutline = "Like_outline_24"
    case search = "Search_16"
    case shareOutline = "Share_outline_24"
    case view = "View_20"
    
    static func image(key: Assets) -> UIImage {
        return UIImage(named: key.rawValue) ?? UIImage()
    }
}
