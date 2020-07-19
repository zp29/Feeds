import Combine

enum AppAction {
    case getToday
    case setToday(posts: [Post])
    
//    case getSubscribers
//    case setSubscribers(subscribers: FeedsServer.Subscriptions)
//    case updateSubscribers(subscribers: FeedsServer.Subscriptions)
    
    case setIsLoading(Bool)
    
    var publisher: AnyPublisher<AppAction, Never> {
        Just(self).eraseToAnyPublisher()
    }
}
