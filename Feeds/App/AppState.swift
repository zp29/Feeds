struct AppState {
    var homeFeed = [Post]()
    var isLoading = false
    var subscribers = Feeds.Subscriptions.empty
}
