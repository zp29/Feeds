import Foundation
import SwiftUI

struct Post: Identifiable, Codable {
    struct Media: Equatable, Codable {
        let source: URL
        let isVideo: Bool
    }

//    enum Service: String, Equatable, Codable {
//        case twitter
//        case instagram
//        case dribbble
//        case github
//        case youtube
//        case reddit
//        case rss
//        case letterboxd
//        case tiktok
//    }
    
    let id: String
    
    let avatar: URL
    let displayName: String
    let username: String
//    let service: Service
//    var serviceImage: Image {
//        switch service {
//        case .twitter:
//            return Image("twitter-logo")
//        case .instagram:
//            return Image("instagram-logo")
//        case .dribbble:
//            return Image("dribbble-logo")
//        case .github:
//            return Image("github-logo")
//        case .youtube:
//            return Image("youtube-logo")
//        case .reddit:
//            return Image("reddit-logo")
//        case .rss:
//            return Image("rss-logo")
//        case .letterboxd:
//            return Image("letterboxd-logo")
//        case .tiktok:
//            return Image("tiktok-logo")
//        }
//    }
    
    let media: [Media]
    var containsMultipleMedia: Bool { media.count > 1 }
    var containsMedia: Bool { !media.isEmpty }
    
    private(set) var title: String? = nil
    private(set) var body: String? = nil
    
    let datePosted: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    var formattedDateTime: String {
        "\(dateFormatter.string(from: datePosted)) • \(timeFormatter.string(from: datePosted))"
    }
    
    let shareURL: URL
}
