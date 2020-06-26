import Combine

final class IGFeedViewModel: ObservableObject {
    private let useDummyData: Bool
    
    @Published private(set) var posts: [IGPostViewModel] = []
    
    var cancellable: AnyCancellable?
    
    init(useDummyData: Bool = false) {
        self.useDummyData = useDummyData
    }
    
    func fetch(_ usernames: [String]) {
        guard !useDummyData else {
            let user = try! User(from: "sardinebrunch-instagram")
            posts = user.timeline.posts.map {
                IGPostViewModel(post: $0, profilePicture: user.profilePictureURL)
            }
            
            return
        }
        
        Publishers.MergeMany(usernames.map(InstagramAPI.publisherFor))
            .map { user in
                user.timeline.posts.map { post in
                    IGPostViewModel(post: post, profilePicture: user.profilePictureURL)
                }
            }
//            .map(posts.appending)
            .map { viewModels in self.posts.appending(contentsOf: viewModels) }
            .replaceError(with: [])
            .assign(to: $posts)
    }
}
