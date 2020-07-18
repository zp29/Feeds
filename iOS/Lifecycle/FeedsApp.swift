import SwiftUI

typealias AppStore = Store<AppState, AppAction, World>

@main
struct FeedsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.deviceType) var deviceType
    
    @StateObject private var store = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: World()
    )
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch deviceType {
                case .pad:
                    PrimaryView()
                case .phone:
                    CompactView()
                default:
                    PrimaryView()
                }
            }
            .environmentObject(store)
        }
    }
}
