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
        Group {
            if store.state.homeFeed.isEmpty {
                ProgressView()
            } else {
                ScrollView {
                    ZStack {
                        Color.primary
                            .colorInvert()
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(dateFormatter.string(from: Date()).uppercased())
                                    // FIXME: Make this a semantic computed property
                                    .fontWeight(.semibold)
                                    .fontSize(13)
                                    .opacity(0.45)
                                
                                Text("Today")
                                    // FIXME: Make this a semantic computed property
                                    .bold()
                                    .fontSize(34)
                            }.padding()
                            
                            ForEach(store.state.homeFeed) { post in
                                Card(post: post)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Today")
        .tabItem {
            Image(systemName: "newspaper.fill")
            Text("Today")
        }
        .onAppear(perform: fetch)
        .pullToRefresh(isReloading: isLoading, action: fetch)
        .visualEffectsStatusBarBackground()
    }
    
    func fetch() {
        store.send(.getToday)
    }
}
