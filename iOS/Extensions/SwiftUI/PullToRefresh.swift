import SwiftUI

extension View {
    func pullToRefresh(isReloading: Binding<Bool>, action: @escaping () -> Void) -> some View {
        background(PullToRefresh(action: action, isReloading: isReloading))
    }
}

public struct PullToRefresh: UIViewRepresentable {
    let action: () -> Void
    @Binding var isReloading: Bool
    
    public init(action: @escaping () -> Void, isReloading: Binding<Bool>) {
        self.action = action
        _isReloading = isReloading
    }
    
    public class Coordinator {
        let action: () -> Void
        let isReloading: Binding<Bool>
        
        init(action: @escaping () -> Void, isReloading: Binding<Bool>) {
            self.action = action
            self.isReloading = isReloading
        }
        
        @objc func onValueChanged() {
            isReloading.wrappedValue = true
            action()
        }
    }
    
    public func makeUIView(context: Context) -> UIView {
        return UIView(frame: .zero)
    }
    
    private func scrollView(root: UIView) -> UIScrollView? {
        for subview in root.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            } else if let scrollView = scrollView(root: subview) {
                return scrollView
            }
        }
        
        return nil
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let viewHost = uiView.superview?.superview else {
                return
            }
            
            guard let scrollView = self.scrollView(root: viewHost) else {
                return
            }
            
            if let refreshControl = scrollView.refreshControl {
                if self.isReloading {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
                
                return
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(action: action, isReloading: $isReloading)
    }
}
