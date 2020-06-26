import Foundation

struct IGPostViewModel: Identifiable, DateSortable {
    var id: String { post.id }
    var url: URL { post.url }
    
    let profilePicture: URL
    var username: String { post.ownerUsername }
    
    var datePosted: Date { post.datePosted }
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: post.datePosted)
    }
    
    var images: [URL] { post.imageURLs }
    var caption: String? { post.caption }
    
    private let post: Post
    
    init(post: Post, profilePicture: URL) {
        self.post = post
        self.profilePicture = profilePicture
    }
}
