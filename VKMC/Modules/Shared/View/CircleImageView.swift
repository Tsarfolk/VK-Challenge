import UIKit

class CircleImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}
