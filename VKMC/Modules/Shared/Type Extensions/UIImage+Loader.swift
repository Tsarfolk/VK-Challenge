import UIKit

private let imageLoader = ImageLoader.shared

extension UIImageView {
    func load(url: String) {
        imageLoader.loadImage(urlString: url) { [weak self] (data) in
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
    }
}
