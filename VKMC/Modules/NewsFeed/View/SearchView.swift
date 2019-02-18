import UIKit

protocol SearchViewDelegate: class {
    func search(for text: String)
    func endSearch()
}

class SearchView: UIView {
    private let userImageView = CircleImageView(frame: .zero)
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = VKMCColors.searchBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let searchImageView = UIImageView(image: Assets.image(key: .search))
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizedString.localized(key: .search)
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    enum State {
        case active
        case inactive
    }
    
    private var rightImageConstraint: NSLayoutConstraint?
    
    private var state: State = .inactive {
        didSet {
            guard state != oldValue else { return }
            
            switch state {
            case .active:
                rightImageConstraint?.constant = 36
            case .inactive:
                rightImageConstraint?.constant = -12
            }
            UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
        }
    }
    
    weak var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User) {
        userImageView.load(url: user.photoUrl)
    }
    
    private func setViews() {
        addSubview(contentView)
        contentView.addSubview(searchImageView)
        contentView.addSubview(textField)
        addSubview(userImageView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        searchImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            searchImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: searchImageView.rightAnchor, constant: 9),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
            ])
        
        
        rightImageConstraint = userImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
            rightImageConstraint?.isActive = true
        NSLayoutConstraint.activate([
            userImageView.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            userImageView.widthAnchor.constraint(equalToConstant: 36),
            userImageView.heightAnchor.constraint(equalToConstant: 36),
            ])
    }
    
    @objc
    private func textFieldTextDidChange() {
        guard let text = textField.text else { return }
        state = text.isEmpty ? .inactive : .active
        if text.count >= 3 {
            delegate?.search(for: text)
        } else if text.isEmpty {
            delegate?.endSearch()
        }
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.endSearch()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
