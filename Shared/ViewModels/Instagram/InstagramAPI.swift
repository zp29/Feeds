import Foundation
import Combine

struct InstagramAPI {
    static func publisherFor(username: String) -> AnyPublisher<User, Error> {
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
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
