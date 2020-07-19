import Foundation
import Combine
import TinyNetworking

extension URL {
    func contains(_ string: String) -> Bool {
        absoluteString.contains(string)
    }
}

struct Reddit {
    private let base = URL(staticString: "https://www.reddit.com")
    
    func getPosts(for subreddits: [String]) -> Endpoint<[Post]> {
        let joinedSubreddits = subreddits.joined(separator: "+")
        let url = base.appendingPathComponent("r/\(joinedSubreddits)/.json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Endpoint<Response>(json: .get, url: url, decoder: decoder)
            .map { response in
                return response.data.children.map { child in
                    let redditPost = child.data
                    
                    // FIXME: How do I get the subreddit avatar/icon?
                    let avi = URL(staticString: "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-180x180.png")
                    let shareURL = URL(string: "https://reddit.com\(child.data.permalink)")!
                    
                    var body: String? = nil
                    var media = [Post.Media]()
                    
                    if redditPost.is_self {
                        body = redditPost.selftext
                    } else if
                        !redditPost.url.contains("reddit.com") ||
                        redditPost.domain != "i.redd.it" ||
                        !redditPost.url.contains("imgur.com")
                    {
                        body = redditPost.url.absoluteString
                    }
                    
                    if redditPost.domain == "i.redd.it" || redditPost.domain.contains("imgur.com") {
                        media = [Post.Media(source: redditPost.url, isVideo: false)]
                    }
                    
                    return Post(
                        id: redditPost.id,
                        avatar: avi,
                        displayName: redditPost.subreddit_name_prefixed,
                        username: "u/\(redditPost.author)",
                        service: "reddit",
                        media: media,
                        title: redditPost.title,
                        body: body,
                        datePosted: redditPost.created_utc,
                        shareURL: shareURL
                    )
                }.sorted()
            }
    }
}

extension Reddit {
    struct Response: Decodable {
        struct Data: Decodable {
            struct Child: Decodable {
                struct Data: Decodable {
                    let created_utc: Date
                    let is_self: Bool
                    let selftext: String
                    let url: URL
                    let domain: String
                    let id: String
                    let subreddit_name_prefixed: String
                    let author: String
                    let title: String?
                    let permalink: String
                }
                
                let data: Child.Data
            }
            
            let children: [Child]
        }
        
        let data: Data
    }

}
