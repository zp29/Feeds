import SwiftUI
import UIKit
//import Introspect

struct CompactAddSubscriptions: View {
    @EnvironmentObject var store: AppStore
    @State var instagramUsers = [String]()
    @State var subreddits = [String]()
    
    @State var igFieldDelegate = TextFieldDelegate()
    
    @Binding var isOpen: Bool
    
    @State var newIGUser = ""
    @State var newSubreddit = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Instagram Users")) {
                    TextField("Add Instagram User", text: $newIGUser)
//                        .introspectTextField { uiTextField in
//                            igFieldDelegate.callback = {
//                                instagramUsers.append(newIGUser)
//                                newIGUser = ""
//                            }
//
//                            uiTextField.delegate = igFieldDelegate
//                        }
                    ForEach(instagramUsers, id:\.self) { username in
                        Text(username)
                    }
                }
                
//                Section(header: Text("Reddit Subreddits")) {
//                    TextField("Add Subreddit", text: $newSubreddit)
//                    ForEach(subreddits, id:\.self) { subreddit in
//                        Text(subreddit)
//                    }
//                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Add Subscriptions")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        defer { isOpen = false }
                        guard !instagramUsers.isEmpty && !subreddits.isEmpty else { return }
                        let sub = FeedsServer.Subscriptions(instagram: instagramUsers, reddit: subreddits)
                        store.send(.updateSubscribers(subscribers: sub))
                    }
                }
            }
            
//            .navigationBarItems(trailing: Button(action: {
//                defer { isOpen = false }
//                guard !instagramUsers.isEmpty && !subreddits.isEmpty else { return }
//                let sub = Feeds.Subscriptions(instagram: instagramUsers, reddit: subreddits)
//                store.send(.updateSubscribers(subscribers: sub))
//            }, label: {
//                Text("Update")
//                    .font(.system(size: 17, weight: .medium, design: .default))
//            }))
            
        }
//        .onAppear(perform: fetch)
    }
}

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var callback: () -> Void
    
    init(_ callback: @escaping () -> Void  = {}) {
        self.callback = callback
        super.init()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        callback()
        textField.resignFirstResponder()
        return true
    }
}
