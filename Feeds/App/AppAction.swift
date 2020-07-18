import Combine

enum AppAction {
    case getToday
    case setToday(posts: [Post])
    
    case getSubscribers
    case setSubscribers(subscribers: Feeds.Subscriptions)
    case updateSubscribers(subscribers: Feeds.Subscriptions)
    
    case setIsLoading(Bool)
    
    var publisher: AnyPublisher<AppAction, Never> {
        Just(self).eraseToAnyPublisher()
    }
}
