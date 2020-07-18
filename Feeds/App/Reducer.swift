import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(state: inout AppState, action: AppAction, environment: World) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case .getToday:
        return environment
            .feeds.getTodayFeed().publisher
            .replaceError(with: [])
            .map { .setToday(posts: $0) }
            .eraseToAnyPublisher()
    case .setToday(posts: let posts):
        state.homeFeed = posts
        return AppAction.setIsLoading(false).publisher

    case .setIsLoading(let bool):
        state.isLoading = bool
        
    case .updateSubscribers(subscribers: let subcribers):
        return environment
            .feeds.updateSubscribers(subcribers).publisher
            .replaceError(with: ())
            .map { _ in .getSubscribers }
            .eraseToAnyPublisher()
    case .getSubscribers:
        return environment
            .feeds.getSubscribers().publisher
            .replaceError(with: Feeds.Subscriptions.empty)
            .map { .setSubscribers(subscribers: $0) }
            .eraseToAnyPublisher()
    case .setSubscribers(subscribers: let sub):
        state.subscribers = sub
        return AppAction.setIsLoading(false).publisher
    }
    
    return nil
}
