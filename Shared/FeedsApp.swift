import SwiftUI

typealias AppStore = Store<AppState, AppAction, World>

@main
struct FeedsApp: App {
    @StateObject var store = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: World()
    )
    
    var body: some Scene {
        WindowGroup {
            HomeFeed()
                .environmentObject(store)
        }
    }
}
