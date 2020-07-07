import Foundation
import SwiftUI

struct HomeFeed: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        Feed(posts: store.state.homeFeed)
            .onAppear(perform: fetch)
    }
    
    private func fetch() {
        store.send(.getHomeFeed)
    }
}
