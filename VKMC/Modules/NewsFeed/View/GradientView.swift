import UIKit

class GradientView: UIView {
    let gradient = CAGradientLayer()
    
    init(fromColor: UIColor, toColor: UIColor) {
        super.init(frame: .zero)
        
        gradient.colors = [fromColor.cgColor, toColor.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = bounds
    }
}
