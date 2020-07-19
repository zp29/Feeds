//import Foundation
//import Combine
//import TinyNetworking
//
//struct Dribbble {
//    private let base = URL(staticString: "https://api.dribbble.com/v2")
//    
//    func getShots(for user: String) -> Endpoint<[Post]> {
//        let url = base.appendingPathComponent("/user/shots?access_token=\(Env.dribbbleAccessToken)")
//        
//        return Endpoint<[Shot]>(json: .get, url: url)
//            .map { shots in
//                return shots.map { shot in
//                    return Post(
//                        id: shot.id.description,
//                        avatar: <#T##URL#>,
//                        displayName: <#T##String#>,
//                        username: <#T##String#>,
//                        service: "dribbble",
//                        media: [Post.Media(source: shot.images.highestResolutionImage, isVideo: false)],
//                        title: shot.title,
//                        body: shot.description,
//                        datePosted: shot.published_at,
//                        shareURL: shot.html_url
//                    )
//                }
//            }
//    }
//}
//
//extension Dribbble {
//    struct Shot: Decodable {
//        let id: Int
//        let title: String
//        // FIXME: This comes in as HTML and I need to notate that so I can render it properly later
//        let description: String
//        let images: Images
//        let published_at: Date
//        let html_url: URL
//    }
//    
//    struct Images: Decodable {
//        let hidpi: URL?
//        let normal: URL
//        let teaser: URL
//        
//        var highestResolutionImage: URL {
//            guard let high = hidpi else {
//                return normal
//            }
//            
//            return high
//        }
//    }
//}
