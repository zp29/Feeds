import SwiftUI
import VisualEffects

struct PrimaryView: View {
    @EnvironmentObject var store: AppStore
    var isLoading: Binding<Bool> { store.binding(for: \.isLoading) { .setIsLoading($0) } }
    
    let columns = [GridItem](repeating: .init(.fixed(343), spacing: 24, alignment: .top), count: 3)
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 48) {
                    ForEach(store.state.homeFeed) { post in
                        Card(post: post)
                    }
                }.padding(48)
            }
            .pullToRefresh(isReloading: isLoading) {
                store.send(.getToday)
            }
            .onAppear { store.send(.getToday) }
            .navigationBarTitle("Feeds")
            
            VStack {
                VisualEffectBlur(blurStyle: .regular, vibrancyStyle: .fill) {
                    EmptyView()
                }
                .frame(width: UIScreen.mainScreen.bounds.size.width, height: 25)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
            }
        }
    }
}
