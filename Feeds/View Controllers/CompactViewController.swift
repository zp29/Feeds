import UIKit

final class CompactViewController: UITabBarController {
    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)
        let homeFeedVC = HomeFeedViewController(store: store)
        setViewControllers([homeFeedVC], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
