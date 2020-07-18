import SwiftUI
import UIKit

struct SplitView<PrimaryView: View, SecondaryView: View, SupplementaryView: View, CompactView: View>: UIViewControllerRepresentable {
    let style: UISplitViewController.Style
    let preferredSplitBehavior: UISplitViewController.SplitBehavior = .automatic
    
    let primaryView: PrimaryView?
    let secondaryView: SecondaryView?
    let supplementaryView: SupplementaryView?
    let compactView: CompactView?
    
//    @Binding var primaryColumnIsHidden: Bool
//    @Binding var secondaryColumnIsHidden: Bool
//    @Binding var supplementaryColumnIsHidden: Bool
//    @Binding var compactColumnIsHidden: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let svc = UISplitViewController(style: style)
        
        svc.setViewController(UIHostingController(rootView: primaryView), for: .primary)
        svc.setViewController(UIHostingController(rootView: secondaryView), for: .secondary)
        svc.setViewController(UIHostingController(rootView: supplementaryView), for: .supplementary)
        svc.setViewController(UIHostingController(rootView: compactView), for: .compact)
        
        return svc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let svc = uiViewController as? UISplitViewController else { return }
        
//        toggleHideShow(state: primaryColumnIsHidden, on: svc, for: .primary)
//        toggleHideShow(state: secondaryColumnIsHidden, on: svc, for: .secondary)
//        toggleHideShow(state: supplementaryColumnIsHidden, on: svc, for: .supplementary)
//        toggleHideShow(state: compactColumnIsHidden, on: svc, for: .compact)
        svc.preferredSplitBehavior = preferredSplitBehavior
    }
    
    private func toggleHideShow(state: Bool, on controller: UISplitViewController, for column: UISplitViewController.Column) {
        if state { controller.hide(column) }
        else { controller.show(column) }
    }
}
