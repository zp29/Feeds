import SwiftUI

struct CompactToday: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    var body: some View {
        NavigationView {
            Group {
                if store.state.homeFeed.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        ZStack {
                            Color.primary
                                .colorInvert()
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack {
                                ForEach(store.state.homeFeed) { post in
                                    Card(post: post)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Today")
        }
        .tabItem {
            Image(systemName: "newspaper.fill")
            Text("Today")
        }
        .onAppear(perform: fetch)
        .pullToRefresh(isReloading: isLoading, action: fetch)
    }
    
    func fetch() {
        store.send(.getToday)
    }
}
