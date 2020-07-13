import Foundation
import SwiftUI

struct HomeFeed: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.deviceType) var device
    
    var body: some View {
        NavigationView {
            if device == .mac {
                Sidebar().frame(minWidth: 160, idealWidth: 180, maxWidth: 200, maxHeight: .infinity)
            } else if device == .iPad {
                Sidebar()
            }
            
            Feed(posts: store.state.homeFeed)
                .navigationTitle("Home Feed")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .status) {
                        Button(action: { }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            
        }.onAppear(perform: fetch)
    }
    
    private func fetch() {
        store.send(.getHomeFeed)
    }
}

struct Sidebar: View {
    @State var selection: Set<Int> = [0]
    
    var body: some View {
        List(selection: self.$selection) {
            Label("Home Feed", systemImage: "house").tag(0)
            
            Group {
                Text("All Feeds")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Label("Politics", systemImage: "books.vertical").tag(1)
                Label("Programming", systemImage: "chevron.left.slash.chevron.right").tag(2)
                Label("Design", systemImage: "paintbrush.pointed").tag(3)
                Label("Food", systemImage: "leaf").tag(4)
            }
            
            Divider()
            
            Group {
                Text("Account")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Label("Profile", systemImage: "person").tag(5)
            }
        }
        .listStyle(SidebarListStyle())
        // FIXME: This displays correctly on iPadOS, but takes over the main toolbar title on macOS
        .navigationTitle("Feeds")
    }
}
