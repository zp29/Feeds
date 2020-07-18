import Foundation
import Combine
import TinyNetworking

struct World {
    let feeds = Feeds()
}

struct Feeds {
    struct Subscriptions: Codable {
        let instagram: [String]
        let reddit: [String]
        
        static let empty = Subscriptions(instagram: [], reddit: [])
    }

    let base = URL(staticString: "http://Marks-BP3-MacBook-Pro.local:3000") // "http://Mac-mini.local:3000"
    
    func getTodayFeed() -> Endpoint<[Post]> {
        Endpoint<[Post]>(json: .get, url: base)
    }
    
    func getSubscribers() -> Endpoint<Feeds.Subscriptions> {
        Endpoint<Feeds.Subscriptions>(json: .get, url: base.appendingPathComponent("subscriptions"))
    }
    
    func updateSubscribers(_ subscribers: Subscriptions) -> Endpoint<()> {
        Endpoint<()>(
            json: .post,
            url: base.appendingPathComponent("subscribers"),
            accept: .json,
            body: subscribers
        )
    }
}

extension Endpoint {
    var publisher: AnyPublisher<A, Error> {
        URLSession.shared.load(self)
    }
}
