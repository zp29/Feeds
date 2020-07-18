import SwiftUI
import VisualEffects

struct PrimaryView: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    // TODO: Sort from left to right, top to bottom; currently sorts top to bottom, left to right
    var feedArray: [[Post]] {
        var counter = 0
        var tmp = [Post]()
        return store.state.todayFeed.compactMap {
            // FIXME: Check this math
            let number = store.state.todayFeed.count / 3
            // TODO: Calculate how to divide the array to have about even view column heights, based on the predicted content size
            
            guard store.state.todayFeed.last != $0 else {
                tmp.append($0)
                return tmp
            }
            
            guard counter != number else {
                counter = 0
                let returnable = tmp
                tmp = []
                return returnable
            }
            
            counter += 1
            tmp.append($0)
            return nil
        }
    }
    
    let columns = [GridItem](repeating: .init(.fixed(343), spacing: 24, alignment: .top), count: 3)
    
    var body: some View {
        // FIXME: The scrolling performance is not great
        ScrollView {
//            VStack(alignment: .leading) {
//                Text("Friday, June 17".uppercased())
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
            
            LazyVStack {
                HStack(alignment: .top) {
                    ForEach(0..<feedArray.count, id: \.self) { array in
                        LazyVStack {
                            ForEach(feedArray[array]) { post in
                                Card(post: post)
                            }
                        }
                    }
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
