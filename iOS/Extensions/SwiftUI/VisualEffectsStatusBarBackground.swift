import SwiftUI
import VisualEffects

struct VisualEffectsStatusBarBackgroundModifier: ViewModifier {
    @Environment(\.deviceType) var deviceType
    
    var isPhone: Bool { deviceType == .phone }
    var isPad: Bool { deviceType == .pad }
    
    var width: CGFloat { UIScreen.main.bounds.size.width }
    // FIXME: This only works for iPhone X-style phones in portrait
    var height: CGFloat {
        guard isPhone else { return 25 }
        return 44
    }
    
    func body(content: VisualEffectsStatusBarBackgroundModifier.Content) -> some View {
        Group {
            if !isPhone && !isPad {
                content
            } else {
                ZStack {
                    content
                    
                    VStack {
                        VisualEffectBlur(blurStyle: .regular, vibrancyStyle: .fill) { EmptyView() }
                        .frame(width: width, height: height)
                        .edgesIgnoringSafeArea(.all)

                        Spacer()
                    }
                }
            }
        }
    }
}

extension View {
    func visualEffectsStatusBarBackground() -> some View {
        self.modifier(VisualEffectsStatusBarBackgroundModifier())
    }
}
