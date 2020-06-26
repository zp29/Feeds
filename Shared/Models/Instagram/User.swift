import Foundation

struct User: Identifiable, Decodable {
    var id: String { instagramID }
    let instagramID: String
    
    let username: String
    let displayName: String
    let biography: String
    let profilePictureURL: URL
    
    let isPrivate: Bool
    let isVerified: Bool
    
    let followerCount: Int
    let followedByCount: Int
    
    let timeline: Timeline
    
    enum CodingKeys: CodingKey {
        case username
        case biography
        case full_name
        case id
        case is_private
        case is_verified
        case profile_pic_url_hd
        case edge_owner_to_timeline_media
        
        case edge_follow
        case edge_followed_by
    }
    
    enum FollowKey: CodingKey {
        case count
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        biography = try values.decode(String.self, forKey: .biography)
        displayName = try values.decode(String.self, forKey: .full_name)
        username = try values.decode(String.self, forKey: .username)
        instagramID = try values.decode(String.self, forKey: .id)
        isPrivate = try values.decode(Bool.self, forKey: .is_private)
        isVerified = try values.decode(Bool.self, forKey: .is_verified)
        profilePictureURL = try values.decode(URL.self, forKey: .profile_pic_url_hd)
        timeline = try values.decode(Timeline.self, forKey: .edge_owner_to_timeline_media)
        
        let follow = try values.nestedContainer(keyedBy: FollowKey.self, forKey: .edge_follow)
        followerCount = try follow.decode(Int.self, forKey: .count)
        
        let followedBy = try values.nestedContainer(keyedBy: FollowKey.self, forKey: .edge_followed_by)
        followedByCount = try followedBy.decode(Int.self, forKey: .count)
    }
}

extension User {
    init(from json: String) throws {
        guard let url = Bundle.main.url(forResource: json, withExtension: "json") else {
            fatalError("Failed to locate \(json).json in bundle.")
        }

        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: Data(contentsOf: url))
    }
}
