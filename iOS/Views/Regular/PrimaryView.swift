import SwiftUI
import VisualEffects

struct PrimaryView: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    let columns = [GridItem](repeating: .init(.fixed(343), spacing: 24, alignment: .top), count: 3)
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = false
        return formatter
    }
    
    var body: some View {
        ScrollView {
//            VStack(alignment: .leading) {
//                Text(dateFormatter.string(from: Date()).uppercased())
//                    // FIXME: Make this a semantic computed property
//                    .fontWeight(.semibold)
//                    .fontSize(13)
//                    .opacity(0.45)
//
//                Text("Today")
//                    // FIXME: Make this a semantic computed property
//                    .bold()
//                    .fontSize(34)
//            }.padding()
            
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
