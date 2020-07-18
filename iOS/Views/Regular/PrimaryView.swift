import SwiftUI
import VisualEffects

struct PrimaryView: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    let columns = [GridItem](repeating: .init(.fixed(343), spacing: 24, alignment: .top), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 48) {
                ForEach(store.state.homeFeed) { post in
                    Card(post: post)
                }
            }.padding(48)
        }
        .visualEffectsStatusBarBackground()
        .pullToRefresh(isReloading: isLoading, action: fetch)
        .onAppear { store.send(.getToday) }
        .navigationBarTitle("Feeds")
    }
    
    func fetch() {
        store.send(.getToday)
    }
}
