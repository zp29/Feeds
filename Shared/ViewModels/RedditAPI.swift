import Foundation
import Combine

enum RedditAPI {
    private static func publisherFor(subreddits: [String]) -> AnyPublisher<[RedditPost], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://reddit.com/r/\(subreddits.joined(separator: "+"))/.json")!)
            .validate()
            .tryMap { data -> Data in
                let json = try JSONSerialization.jsonObject(with: data) as! [String : Any]
                let datum = json["data"] as! [String : Any]
                let root = datum["children"]
                return try JSONSerialization.data(withJSONObject: root!)
            }
            .decode(type: [RedditPost].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func viewModelPublisherFor(subreddits: [String]) -> AnyPublisher<[CardViewModel], Never> {
        publisherFor(subreddits: subreddits)
            .map { posts in
                posts.map { post in
                    CardViewModel(
                        id: post.data.id,
                        avatar: post.data.url, // FIXME
                        displayName: post.data.subreddit_name_prefixed,
                        username: "u/\(post.data.author)",
                        service: .reddit,
                        media: [
                            CardViewModel.Media(source: post.data.thumbnail, isVideo: post.data.is_video) // FIXME
                        ],
                        title: post.data.title,
                        body: post.data.selftext,
                        datePosted: Date(timeIntervalSince1970: post.data.created_utc),
                        shareURL: URL(string: "https://reddit.com\(post.data.permalink)")!
                    )
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
