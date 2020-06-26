import SwiftUI

struct InstagramFeed: View {
    @StateObject var viewModel: IGFeedViewModel
    
    // FIXME: How do I make this use @AppStorage?
    @State var usernames: [String] = [
        "sardinebrunch", "gabbingwithbabish", "baohaus",
        "eataustinlocal", "foodbyromilly",
        "noshwithtash", "mnnfrr", "testcook"
    ]
    
//    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    Color.primary
                        .colorInvert()
                        .edgesIgnoringSafeArea(.all)
                    
                    LazyVStack {
                        ForEach(viewModel.posts.sorted()) { post in
                            NavigationLink(destination: InstagramContent(viewModel: post)) {
                                InstagramCard(viewModel: post)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .onAppear { viewModel.fetch(usernames) }
            .navigationBarTitle("Feeds")
//            .navigationBarItems(trailing: Button(action: {
//                showAddView = true
//            }, label: {
//                Image(systemName: "plus.circle.fill")
//            }))
//            .sheet(isPresented: $showAddView) {
//                // FIXME: This causes a crash for some reason...
//                // viewModel.fetch(usernames)
//            } content: {
//                AddNewInstagramFeeds(usernames: $usernames)
//            }
        }
    }
    
}
