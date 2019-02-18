import UIKit

class PostSearchView: UIView {
    private let userImageView = CircleImageView(frame: .zero)
    private let searchView = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: UISearchBarDelegate? {
        didSet {
            searchView.delegate = delegate
        }
    }
    
    func configure(searchedText: String?, user: User?) {
        searchView.text = searchedText
        if let photoUrl = user?.photoUrl {
            userImageView.load(url: photoUrl)
        }
    }
    
    private func setViews() {
        addSubview(userImageView)
        addSubview(searchView)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: leftAnchor),
            searchView.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            userImageView.leftAnchor.constraint(equalTo: searchView.rightAnchor, constant: 12),
            userImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 12),
            userImageView.widthAnchor.constraint(equalToConstant: 36),
            userImageView.heightAnchor.constraint(equalToConstant: 36)
            ])
    }
}
