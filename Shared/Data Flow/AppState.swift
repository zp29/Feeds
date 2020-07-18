struct AppState {
    var homeFeed = [Post]()
    var isLoading = false
    var subscribers = FeedsServer.Subscriptions.empty
}
