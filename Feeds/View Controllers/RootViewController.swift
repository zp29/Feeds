import UIKit

typealias AppStore = Store<AppState, AppAction, World>

final class RootViewController: UISplitViewController {
    private let store = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: World()
    )
    
    init() {
        super.init(style: .tripleColumn)
        // MARK: iPad/Mac column layout
        // setViewController(<#T##vc: UIViewController?##UIViewController?#>, for: .primary)
        // setViewController(<#T##vc: UIViewController?##UIViewController?#>, for: .supplementary)
        // setViewController(<#T##vc: UIViewController?##UIViewController?#>, for: .secondary)
        
        // MARK: iPhone tab bar layout
        let compactVC = CompactViewController(store: store)
        setViewController(compactVC, for: .compact)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
