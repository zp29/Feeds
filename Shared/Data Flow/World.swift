import Foundation
import Combine
import TinyNetworking

struct World {
    let feedsServer = FeedsServer()
}

struct FeedsServer {
    let base = URL(staticString: "http://Marks-Mac-mini.local:3000") // "http://Marks-BP3-MacBook-Pro.local:3000"
    
    func getTodayFeed() -> Endpoint<[Post]> {
        Endpoint<[Post]>(json: .get, url: base)
    }
    
    func getSubscribers() -> Endpoint<Subscriptions> {
        Endpoint<Subscriptions>(json: .get, url: base.appendingPathComponent("subscriptions"))
    }
    
    func updateSubscribers(_ subscribers: Subscriptions) -> Endpoint<()> {
        Endpoint(
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
