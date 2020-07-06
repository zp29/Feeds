import Foundation
import Combine

enum InstagramAPI {
    private static func publisherFor(username: String) -> AnyPublisher<User, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://www.instagram.com/\(username)/?__a=1")!)
            .validate()
            .tryMap { data -> Data in
                let json = try JSONSerialization.jsonObject(with: data) as! [String : Any]
                let gql = json["graphql"] as! [String : Any]
                let root = gql["user"]
                return try JSONSerialization.data(withJSONObject: root!)
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func viewModelPublisherFor(username: String) -> AnyPublisher<[CardViewModel], Never> {
        publisherFor(username: username)
            .map { user in
                user.timeline.posts.map { post in
                    CardViewModel(
                        id: post.id,
                        avatar: user.profilePictureURL,
                        displayName: user.displayName,
                        username: user.username,
                        service: .instagram,
                        media: post.imageURLs.map { imageURL in
                            CardViewModel.Media(source: imageURL, isVideo: post.isVideo)
                        },
                        body: post.caption?.replacingOccurrences(
                            of: "#(?:\\S+)\\s?",
                            with: "",
                            options: .regularExpression
                        ),
                        datePosted: post.datePosted,
                        shareURL: post.url
                    )
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
