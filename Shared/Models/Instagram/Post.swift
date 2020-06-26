import Foundation

struct Post: Identifiable, Decodable {
    var id: String { instagramID }
    let instagramID: String
    
    private let shortcode: String
    var url: URL {
        URL(string: "https://www.instagram.com/p/\(shortcode)")!
    }
    
    let ownerID: String
    let ownerUsername: String
    
    let isVideo: Bool
    let datePosted: Date
    
    let caption: String?
    let imageURLs: [URL]
    
    enum RootKey: CodingKey {
        case node
    }
    
    enum CodingKeys: CodingKey {
        case id
        case shortcode
        case owner
        case is_video
        case edge_media_to_caption
        case edge_sidecar_to_children
        case display_url
        case taken_at_timestamp
    }
    
    enum Owner: CodingKey {
        case id
        case username
    }
    
    enum EdgeRoot: CodingKey {
        case edges
    }
    
    enum Edges: CodingKey {
        case node
    }
    
    enum CaptionNodeKey: CodingKey {
        case text
    }
    
    enum ImageNodeKey: CodingKey {
        case display_url
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKey.self)
        let values = try root.nestedContainer(keyedBy: CodingKeys.self, forKey: .node)
        
        instagramID = try values.decode(String.self, forKey: .id)
        shortcode = try values.decode(String.self, forKey: .shortcode)
        isVideo = try values.decode(Bool.self, forKey: .is_video)
        let timeIntervalSince1970 = try values.decode(Double.self, forKey: .taken_at_timestamp)
        datePosted = Date(timeIntervalSince1970: timeIntervalSince1970)
        
        let owner = try values.nestedContainer(keyedBy: Owner.self, forKey: .owner)
        ownerID = try owner.decode(String.self, forKey: .id)
        ownerUsername = try owner.decode(String.self, forKey: .username)
        
        let edgeMediaToCaption = try values.nestedContainer(keyedBy: EdgeRoot.self, forKey: .edge_media_to_caption)
        var captionEdges = try edgeMediaToCaption.nestedUnkeyedContainer(forKey: .edges)
        
        var captions = [String]()
        
        while !captionEdges.isAtEnd {
            let node = try captionEdges.nestedContainer(keyedBy: Edges.self)
            let text = try node.nestedContainer(keyedBy: CaptionNodeKey.self, forKey: .node)
            captions.append(try text.decode(String.self, forKey: .text))
        }
        
        caption = captions.first?
            // Remove hashtags
            .replacingOccurrences(
                of: "#(?:\\S+)\\s?",
                with: "",
                options: .regularExpression
            )
        
        var images = [URL]()
        
        let displayURL = try values.decode(String.self, forKey: .display_url)
        images.append(URL(string: displayURL)!)
        
        if let edgeSidecarToChildren = try? values.nestedContainer(keyedBy: EdgeRoot.self, forKey: .edge_sidecar_to_children) {
            var imageEdges = try edgeSidecarToChildren.nestedUnkeyedContainer(forKey: .edges)
            
            while !imageEdges.isAtEnd {
                let node = try imageEdges.nestedContainer(keyedBy: Edges.self)
                let imageContainer = try node.nestedContainer(keyedBy: ImageNodeKey.self, forKey: .node)
                let imageString = try imageContainer.decode(String.self, forKey: .display_url)
                images.append(URL(string: imageString)!)
            }
            
            guard !images.isEmpty else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: values.codingPath + [CodingKeys.edge_sidecar_to_children],
                        debugDescription: "edge_sidecar_to_children must contain at least one image display_url"
                    )
                )
            }
        }
        
        self.imageURLs = images.removingDuplicates()
    }
}

extension Post: Filterable {
    func contains(keyword: String) -> Bool {
        guard let caption = caption else {
            return false
        }
        
        return caption.contains(keyword)
    }
    
    func wasPostedBy(username: String) -> Bool {
        username == ownerUsername
    }
}

extension Post: DateSortable {}
