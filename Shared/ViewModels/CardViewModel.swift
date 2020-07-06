import Foundation
import SwiftUI

struct CardViewModel: Identifiable, DateSortable {
    struct Media: Equatable {
        let source: URL
        let isVideo: Bool
//        var isImage: Bool { !isVideo }
    }

    enum Service: Equatable {
        case twitter
        case instagram
        case dribbble
        case github
        case youtube
        case reddit
        case rss
        case letterboxd
    }
    
    let id: String
    
    let avatar: URL
    let displayName: String
    let username: String
    let service: Service
    var serviceImage: Image {
        switch service {
        case .twitter:
            return Image("twitter-logo")
        case .instagram:
            return Image("instagram-logo")
        case .dribbble:
            return Image("dribbble-logo")
        case .github:
            return Image("github-logo")
        case .youtube:
            return Image("youtube-logo")
        case .reddit:
            return Image("reddit-logo")
        case .rss:
            return Image("rss-logo")
        case .letterboxd:
            return Image("letterboxd-logo")
        }
    }
    
    let media: [Media]
    var containsMultipleMedia: Bool { media.count > 1 }
    var containsMedia: Bool { !media.isEmpty }
    
    private(set) var title: String? = nil
//    var containsTitle: Bool { title != nil }
    private(set) var body: String? = nil
//    var containsBody: Bool { body != nil }
    
    let datePosted: Date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private(set) lazy var formattedDateTime: String = "\(dateFormatter.string(from: datePosted)) • \(timeFormatter.string(from: datePosted))"
    
    let shareURL: URL
    var isBookmarked: Bool = false
}

extension CardViewModel: Filterable {
    func contains(keyword: String) -> Bool {
        if let body = body, body.contains(keyword) { return true }
        if let title = title, title.contains(keyword)  { return true }
        return false
    }
    
    func wasPostedBy(username: String) -> Bool {
        self.username == username
    }
}
