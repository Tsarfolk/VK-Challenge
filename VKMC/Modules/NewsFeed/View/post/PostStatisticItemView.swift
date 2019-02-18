import UIKit

class PostStatisticItemView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = VKMCColors.greyTitle
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = VKMCColors.greyTitle
        label.font = VKMCFonts.medium(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, title: String, spacing: CGFloat) {
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        stackView.spacing = spacing
    }
    
    private func setViews() {
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
