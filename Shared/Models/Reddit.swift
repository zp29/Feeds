import Foundation

struct RedditPost: Decodable {
    let data: RedditPostData
}

struct RedditPostData: Decodable {
    let subreddit_name_prefixed: String
    let selftext: String?
    let author: String
    let title: String?
    let subreddit_type: String
    let spoiler: Bool
    let id: String
    let url: URL
    let created_utc: Double
    let is_video: Bool
    let thumbnail: URL
    let permalink: String
}
