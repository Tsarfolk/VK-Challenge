import UIKit

class PostPhotosView: UIView {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = VKMCColors.blueDot.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = VKMCColors.blueDot
        return pageControl
    }()
    
    private var heightConstaint: NSLayoutConstraint?
    private var bottomConstaint: NSLayoutConstraint?
    
    private var urls: [String] = [] {
        didSet {
            if urls.count == 0 {
                pageControl.isHidden = true
                heightConstaint?.constant = 0
            } else if urls.count == 1 {
                pageControl.isHidden = true
                heightConstaint?.constant = 250
                collectionView.frame.size.height = 250
                bottomConstaint?.constant = -10
            } else {
                pageControl.isHidden = false
                heightConstaint?.constant = 290
                collectionView.frame.size.height = 290
                bottomConstaint?.constant = -40
            }
            pageControl.numberOfPages = urls.count
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ urls: [String]) {
        self.urls = urls
        collectionView.isScrollEnabled = urls.count > 1
    }
    
    private func setViews() {
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = VKMCColors.clear
        collectionView.clipsToBounds = false
        collectionView.bounces = false
        collectionView.register(PostPhotoCell.self, forCellWithReuseIdentifier: PostPhotoCell.vkmcReuseIdentifier)
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        bottomConstaint = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstaint?.isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
        
        heightConstaint = heightAnchor.constraint(equalToConstant: 290)
        heightConstaint?.isActive = true
    }
}

extension PostPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
}

extension PostPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostPhotoCell.vkmcReuseIdentifier, for: indexPath) as! PostPhotoCell
        let url = urls[indexPath.row]
        cell.configure(url)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let floatPage = max(0, scrollView.contentOffset.x / (collectionView.frame.width - 12 * 2))
        pageControl.currentPage = min(Int(floatPage), urls.count - 1)
    }
}
