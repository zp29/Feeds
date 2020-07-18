import SwiftUI

struct CompactView: View {
    var body: some View {
        TabView {
            CompactToday()
             CompactSubscriptions()
        }
    }
}
