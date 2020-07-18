extension FeedsServer {
    struct Subscriptions: Codable {
        let instagram: [String]
        let reddit: [String]
        
        static let empty = Subscriptions(instagram: [], reddit: [])
    }
}
