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
//                .frame(
//                    minWidth: 560,
//                    idealWidth: 680,
//                    maxWidth: 800,
//                    minHeight: 640,
//                    idealHeight: 980,
//                    maxHeight: .infinity
//                )
        }
    }
}
