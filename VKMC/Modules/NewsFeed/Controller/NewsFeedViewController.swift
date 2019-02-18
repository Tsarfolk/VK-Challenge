import UIKit

class NewsFeedViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 36, width: 0, height: 0))
    private let searchView = SearchView()
    
    private var searchViewTopConstraint: NSLayoutConstraint?
    
    private var user: User? { return viewModel.user }
    private var posts: [Post] { return viewModel.posts }
    private var isExpanded = NSMutableSet()
    private var calculatedHeight: [Int: CGFloat] = [:]
    
    private let viewModel: NewsFeedViewModel
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = GradientView(fromColor: VKMCColors.gradientFrom, toColor: VKMCColors.gradientTo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = VKMCColors.lightGrey
        
        setViews()
        setupBindings()
        
        viewModel.loadUser()
        viewModel.loadFeed()
    }
    
    private func setupBindings() {
        viewModel.postsUpdated = { [weak self] in
            guard let sSelf = self else { return }
            // optimise to insert
            sSelf.collectionView.reloadData()
            sSelf.refreshControl.endRefreshing()
        }
        viewModel.stateChanged = { [weak self] state in
            guard let sSelf = self else { return }
            
            sSelf.collectionView.reloadSections(IndexSet(arrayLiteral: 1))
        }
        viewModel.userLoaded = { [weak self] user in
            guard let sSelf = self else { return }
            sSelf.searchView.configure(user: user)
        }
        viewModel.clearCache = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.calculatedHeight = [:]
        }
    }
    
    private func setViews() {
        view.addSubview(collectionView)
        view.addSubview(searchView)
        
        refreshControl.addTarget(self, action: #selector(refreshControlChange), for: .valueChanged)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.bounds.origin.y -= 50
        collectionView.backgroundView = GradientView(fromColor: VKMCColors.gradientFrom, toColor: VKMCColors.gradientTo)
        collectionView.backgroundColor = VKMCColors.clear
        collectionView.register(PostCell.self,
                                forCellWithReuseIdentifier: PostCell.vkmcReuseIdentifier)
        collectionView.register(PostFooterView.self,
                                forCellWithReuseIdentifier: PostFooterView.vkmcReuseIdentifier)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 1.0)
                ])
        } else {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                bottomLayoutGuide.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
                ])
        }
    
        searchView.delegate = self
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchViewTopConstraint = searchView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 12)
        searchViewTopConstraint?.isActive = true
        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 36)
            ])
    }
    
    @objc
    private func refreshControlChange() {
        viewModel.reload()
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section == 0 else {
            return CGSize(width: collectionView.frame.width, height: 36)
        }
        
        let cellWidth = collectionView.frame.width - 8 * 2
        let index = indexPath.row
        let post = posts[index]
        
        if let cachedHeight = calculatedHeight[index] {
            return CGSize(width: cellWidth,
                          height: cachedHeight)
        }
        
        // author + date
        let authorHeader: CGFloat = 12 + 36
        
        // post description
        let textFont = VKMCFonts.regular(ofSize: 15)
        let lineHeight = textFont.lineHeight
        let lineTopOffset: CGFloat = 12
        var textHeight = post.text.height(withConstrainedWidth: cellWidth - 12 * 2, font: textFont)
        if !isExpanded.contains(index) {
            if textHeight / lineHeight > 7 {
                textHeight = lineHeight * 8
            }
        }
        let lineBottomOffset: CGFloat = 6
        let overallTextHeight = post.text.isEmpty ? lineTopOffset + 6 : lineTopOffset + textHeight + lineBottomOffset
        
        // images
        var imageHeight: CGFloat = 0
        if post.photoUrlStrings.count == 1 {
            // without page control
            imageHeight = 250
        } else if post.photoUrlStrings.count > 1 {
            // with page control
            imageHeight = 290
        }
        let statisticHeight: CGFloat = 44
        
        let overallHeight = authorHeader + overallTextHeight + imageHeight + statisticHeight
        calculatedHeight[index] = overallHeight
        return CGSize(width: cellWidth,
                      height: overallHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 60, left: 8, bottom: 8, right: 8)
        case 1:
            return UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        default:
            return .zero
        }
    }
}

extension NewsFeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return posts.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.vkmcReuseIdentifier, for: indexPath) as! PostCell
            let index = indexPath.row
            let post = posts[index]
            cell.delegate = self
            cell.configure(post, shouldExpand: isExpanded.contains(index), searchText: viewModel.currentSearch)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostFooterView.vkmcReuseIdentifier, for: indexPath) as! PostFooterView
            // fast solution for pagination, number of posts will be beraly visible
            if viewModel.isSearchActive {
                viewModel.loadNextPageForSearch()
            } else {
                viewModel.loadFeed()
            }
            cell.configure(state: viewModel.state)
            return cell
        default:
            fatalError("Section which is greate then 2 is invalid")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < posts.count else { return }
        let post = posts[indexPath.row]
        ImageLoader.shared.suspend(urls: post.allPhotoUrls)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchViewTopConstraint?.constant = -min(max(-12, scrollView.contentOffset.y - 12), 80)
        view.endEditing(true)
    }
}

extension NewsFeedViewController: PostCellDelegate {
    func expandButtonDidTouch(at cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let index = indexPath.row
        isExpanded.add(index)
        calculatedHeight[index] = nil
        collectionView.reloadItems(at: [indexPath])
    }
}

extension NewsFeedViewController: SearchViewDelegate {
    func search(for text: String) {
        viewModel.search(text: text)
    }
    
    func endSearch() {
        viewModel.clearSearch()
    }
}
