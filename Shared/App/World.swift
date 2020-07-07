import Foundation
import Combine

struct World {
    let service = FeedsService()
}

struct FeedsService {
    let serverURL = URL(string: "http://localhost:3000")!
    
    func homeFeedPublisher() -> AnyPublisher<[Post], Error> {
        URLSession.shared
            .dataTaskPublisher(for: serverURL)
            .validate()
            .decode(type: [Post].self, decoder: JSONDecoder())
            .print()
            .eraseToAnyPublisher()
    }
}
