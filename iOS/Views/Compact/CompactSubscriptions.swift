import SwiftUI

struct CompactSubscriptions: View {
    let title = "Subscriptions"
    
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    @State var showAddView = false
    
    var body: some View {
        NavigationView {
            Group {
                if store.state.todayFeed.isEmpty {
                    ProgressView()
                } else {
                    List {
                        Section(header: Text("Instagram Users")) {
                            ForEach(store.state.subscribers.instagram, id:\.self) { username in
                                Text(username)
                            }
                        }
                        
                        Section(header: Text("Reddit Subreddits")) {
                            ForEach(store.state.subscribers.reddit, id:\.self) { subreddit in
                                Text(subreddit)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle(title)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button { showAddView = true } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 22))
                            }

                        }
                    }
                    .sheet(isPresented: $showAddView, onDismiss: update) {
                        CompactAddSubscriptions(isOpen: $showAddView)
                    }
                }
            }
        }
        .tabItem {
            Image(systemName: "rectangle.stack.fill")
            Text(title)
        }
        .onAppear(perform: fetch)
        .pullToRefresh(isReloading: isLoading, action: fetch)
    }
    
    func fetch() {
        store.send(.getSubscribers)
    }
    
    func update() {
        store.send(.updateSubscribers(subscribers: FeedsServer.Subscriptions.empty))
    }
}
