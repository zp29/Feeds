import SwiftUI

struct AddNewInstagramFeeds: View {
    @Binding var usernames: [String]
    @State var currentUsername = ""
    
    var body: some View {
        NavigationView {
            List {
                TextField("Add a User", text: $currentUsername) {
                    usernames.append(currentUsername)
                    currentUsername = ""
                }
                
                ForEach(usernames, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

