import UIKit

class PostFooterView: UICollectionViewCell {
    private let postCountLabel: UILabel = {
        let label = UILabel()
        label.font = VKMCFonts.regular(ofSize: 13)
        label.textColor = VKMCColors.grayColorFooterTitle
        return label
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let acitivityIndicator = UIActivityIndicatorView(style: .gray)
        acitivityIndicator.tintColor = VKMCColors.greyTitle
        return acitivityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(state: NewsFeedViewModelState) {
        switch state {
        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            postCountLabel.isHidden = true
        case .normal(let postCount):
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            postCountLabel.isHidden = false
            postCountLabel.text = LocalizableKeys.localized(key: .posts, with: postCount)
        }
    }
    
    private func setViews() {
        addSubview(postCountLabel)
        addSubview(activityIndicator)
        
        postCountLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            postCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
}
