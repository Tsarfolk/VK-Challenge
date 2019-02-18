import UIKit

protocol PostCellDelegate: class {
    func expandButtonDidTouch(at cell: UICollectionViewCell)
}

class PostCell: UICollectionViewCell {
    private let authorImageView = CircleImageView(frame: .zero)
    private let authorMetaContainerView = UIView()
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = VKMCColors.blackTitle
        label.textAlignment = .left
        label.font = VKMCFonts.medium(ofSize: 14)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = VKMCColors.greyTitle
        label.textAlignment = .left
        label.font = VKMCFonts.regular(ofSize: 12)
        return label
    }()
    private let expandableTitleView = PostExpandableDesciptionView(frame: .zero)
    private let photosView = PostPhotosView(frame: .zero)
    private let statistisView = PostStatisticView(frame: .zero)
    
    weak var delegate: PostCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.backgroundColor = VKMCColors.white
        layer.shadowColor = VKMCColors.postShadow.cgColor
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 24)
        layer.masksToBounds = false
        
        setViews()
        setupBindings()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ post: Post, shouldExpand: Bool, searchText: String?) {
        authorImageView.load(url: post.authorPhotoUrlString)
        authorNameLabel.text = post.authorFullName
        dateLabel.text = post.dateDescription
        expandableTitleView.configure(text: post.text, shouldExpand: shouldExpand, searchText: searchText)
        photosView.isHidden = post.photoUrlStrings.isEmpty
        photosView.configure(post.photoUrlStrings)
        statistisView.configure(likesDescription: post.likeDescription,
                                commentDescription: post.commentsDescription,
                                repostDescription: post.repostsDescription,
                                viewsDescription: post.viewsDescription)
    }
    
    private func setupBindings() {
        expandableTitleView.expandButtonDidTouchCallback = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.delegate?.expandButtonDidTouch(at: sSelf)
        }
    }
    
    private func setViews() {
        addSubviews()
        
        NSLayoutConstraint.activate([
            authorImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            authorImageView.heightAnchor.constraint(equalToConstant: 36),
            authorImageView.widthAnchor.constraint(equalToConstant: 36)
            ])
        
        NSLayoutConstraint.activate([
            authorMetaContainerView.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorMetaContainerView.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: 10)
            ])
        
        NSLayoutConstraint.activate([
            expandableTitleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            expandableTitleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            expandableTitleView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 10),
            ])
        
        NSLayoutConstraint.activate([
            photosView.topAnchor.constraint(equalTo: expandableTitleView.bottomAnchor),
            photosView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            photosView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            statistisView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            statistisView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            statistisView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statistisView.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        // ...
        
        NSLayoutConstraint.activate([
            authorNameLabel.leftAnchor.constraint(equalTo: authorMetaContainerView.leftAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: authorMetaContainerView.topAnchor),
            authorNameLabel.rightAnchor.constraint(equalTo: authorMetaContainerView.rightAnchor)
            ])
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: authorMetaContainerView.leftAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: authorMetaContainerView.bottomAnchor),
            dateLabel.rightAnchor.constraint(equalTo: authorMetaContainerView.rightAnchor),
            dateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 1)
            ])
    }
    
    private func addSubviews() {
        [
            authorImageView,
            authorMetaContainerView,
            expandableTitleView,
            photosView,
            statistisView
            ].forEach { (view) in
                contentView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            authorNameLabel,
            dateLabel
            ].forEach { (label) in
                authorMetaContainerView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
