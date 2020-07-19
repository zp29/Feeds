import SwiftUI

struct CompactToday: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = false
        return formatter
    }
    
    var body: some View {
        NavigationView {
            Group {
                if store.state.todayFeed.isEmpty {
                    ProgressView()
                } else {
                    List { // ScrollView
                        ForEach(store.state.todayFeed) { post in
                            Content(post: post)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .navigationTitle("Today")
                    .pullToRefresh(isReloading: isLoading, action: fetch)
                }
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
