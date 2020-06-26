import SwiftUI

@main
struct FeedsApp: App {
    @StateObject var store = IGFeedViewModel()
    
    var body: some Scene {
        WindowGroup {
            InstagramFeed(viewModel: store)
        }
    }
}
