import UIKit
import SwiftUI

final class FeedCellContentView: UIView, UIContentView {
    let post: Post
    
    var configuration: UIContentConfiguration {
        get { FeedsContentConfiguration(post: post) }
        set {}
    }
    
    init(post: Post) {
        self.post = post
        
        let feedsCell = FeedCell(post: post)
        let hostingVC = UIHostingController(rootView: feedsCell)
        
        super.init(frame: hostingVC.view.frame)
        
        addSubview(hostingVC.view)
        hostingVC.view.preservesSuperviewLayoutMargins = false
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingVC.view.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            hostingVC.view.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            hostingVC.view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FeedsContentConfiguration: UIContentConfiguration {
    var post: Post
    
    func makeContentView() -> UIView & UIContentView {
        FeedCellContentView(post: post)
    }
    
    func updated(for state: UIConfigurationState) -> FeedsContentConfiguration {
        FeedsContentConfiguration(post: post)
    }
}
