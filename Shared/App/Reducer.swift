import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(state: inout AppState, action: AppAction, environment: World) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case .setHomeFeed(posts: let posts):
        state.homeFeed = posts
    case .getHomeFeed:
        return environment.service
            .homeFeedPublisher()
            .replaceError(with: [])
            .map { .setHomeFeed(posts: $0) }
            .eraseToAnyPublisher()
    }
    
    return nil
}
