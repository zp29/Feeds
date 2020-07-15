import UIKit
import Combine

final class HomeFeedViewController: UINavigationController {
    private let collectionVC = makeCollectionVC()
    private lazy var dataSource = makeDataSource()
    
    private let store: AppStore
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: AppStore) {
        self.store = store
        super.init(rootViewController: collectionVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindState()
        setupRefreshControl()
        fetch()
    }
    
    @objc func fetch() {
        store.send(.getHomeFeed)
    }

    func bindState() {
        store.$state.sink { [weak self] state in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(state.homeFeed, toSection: .only)
            self?.dataSource.apply(snapshot)
        }.store(in: &cancellables)
    }
    
    func setupRefreshControl() {
        collectionVC.collectionView.refreshControl = UIRefreshControl()
        collectionVC.collectionView.refreshControl?.addTarget(
            collectionVC,
            action: #selector(fetch),
            for: .valueChanged
        )
    }
}

extension HomeFeedViewController {
    enum Section: CaseIterable {
        case only
    }
    
    static func makeCollectionVC() -> UICollectionViewController {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let viewController = UICollectionViewController(collectionViewLayout: layout)
        
        viewController.title = "Home Feed"
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        return viewController
    }
    
    func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Post> {
        UICollectionView.CellRegistration { cell, indexPath, post in
            cell.contentConfiguration = FeedsContentConfiguration(post: post)
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Post> {
        UICollectionViewDiffableDataSource<Section, Post>(collectionView: collectionVC.collectionView) {
            view, indexPath, item in
            
            view.dequeueConfiguredReusableCell(
                using: self.makeCellRegistration(),
                for: indexPath,
                item: item
            )
        }
    }
}
