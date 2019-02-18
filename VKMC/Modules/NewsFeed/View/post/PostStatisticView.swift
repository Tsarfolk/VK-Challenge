import UIKit

class PostStatisticView: UIView {
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = VKMCColors.lineSeparator
        return view
    }()
    private let likesView = PostStatisticItemView(frame: .zero)
    private let commentsView = PostStatisticItemView(frame: .zero)
    private let repostsView = PostStatisticItemView(frame: .zero)
    private let viewsView = PostStatisticItemView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(likesDescription: String,
                   commentDescription: String,
                   repostDescription: String,
                   viewsDescription: String) {
        likesView.configure(image: Assets.image(key: .likeOutline),
                            title: likesDescription,
                            spacing: 5.1)
        commentsView.configure(image: Assets.image(key: .commentOutline),
                            title: commentDescription,
                            spacing: 6.1)
        repostsView.configure(image: Assets.image(key: .shareOutline),
                            title: repostDescription,
                            spacing: 4.3)
        viewsView.configure(image: Assets.image(key: .view),
                            title: viewsDescription,
                            spacing: 5)
    }
    
    private func setViews() {
        let stackView = UIStackView(arrangedSubviews: [likesView, commentsView, repostsView])
        stackView.axis = .horizontal
        stackView.spacing = 40
        
        addSubview(separatorLineView)
        addSubview(stackView)
        addSubview(viewsView)
        
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            separatorLineView.topAnchor.constraint(equalTo: topAnchor),
            separatorLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 17),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            ])
        
        NSLayoutConstraint.activate([
            viewsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            viewsView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            ])
    }
}
