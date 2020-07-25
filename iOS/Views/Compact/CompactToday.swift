import SwiftUI

struct CompactToday: View {
    private let title = "Today"
    
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    func post(data: Post) -> some View {
        Content(post: data).buttonStyle(PlainButtonStyle())
    }
        
    var content: some View {
        List {
            ForEach(store.state.todayFeed) { todayPost in
                post(data: todayPost)
            }
        }
        .navigationTitle(title)
        .pullToRefresh(isReloading: isLoading, action: fetch)
    }
    
    var placeholder: some View {
        List {
            ForEach(1..<20) { _ in
                // TODO: Randomize which ones have media
                post(data: Post.placeholder)
            }
        }
        .navigationTitle(title)
        .redacted(reason: .placeholder)
    }
    
    var body: some View {
        NavigationView {
            if store.state.isLoading {
                placeholder
            } else {
                content
            }
        }
        .tabItem {
            Image(systemName: "newspaper.fill")
            Text("Today")
        }
        .onAppear(perform: fetch)
    }
    
    func fetch() {
        store.send(.getToday)
    }
}
