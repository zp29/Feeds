struct Timeline: Decodable {
    let postCount: Int
    let hasNextPage: Bool
    let endCursor: String
    
    let posts: [Post]
    
    enum CodingKeys: CodingKey {
        case count
        case page_info
        case edges
    }
    
    enum PageInfo: CodingKey {
        case has_next_page
        case end_cursor
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postCount = try values.decode(Int.self, forKey: .count)
        let postArray = try values.decode([Post].self, forKey: .edges)
        posts = postArray.sorted()
        
        let pageInfo = try values.nestedContainer(keyedBy: PageInfo.self, forKey: .page_info)
        hasNextPage = try pageInfo.decode(Bool.self, forKey: .has_next_page)
        endCursor = try pageInfo.decode(String.self, forKey: .end_cursor)
    }
}
