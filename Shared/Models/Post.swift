import Foundation
import UIKit

struct Post: Hashable, Identifiable, Codable {
    let id: String
    
    let avatar: URL
    let displayName: String
    let username: String
    
    let service: String
    var serviceImageName: String {
        guard UIImage(named: "\(service)-logo") != nil else {
            return "rss-logo"
        }
        
        return "\(service)-logo"
    }
    
    let media: [Media]
    var containsMultipleMedia: Bool { media.count > 1 }
    var containsMedia: Bool { !media.isEmpty }
    
    private(set) var title: String? = nil
    private(set) var body: String? = nil
    
    var bodyURL: URL? {
        guard let body = body,
              let url = URL(string: body)
        else { return nil }
        
        return url
    }
    
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
    
    // FIXME: This was coming in malformed from the server
    let shareURL: URL
}

extension Post: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.datePosted > rhs.datePosted
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.datePosted >= rhs.datePosted
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.datePosted <= rhs.datePosted
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.datePosted < rhs.datePosted
    }
}

extension Post {
    struct Media: Hashable, Codable {
        // let id = UUID()
        let source: URL
        let isVideo: Bool
    }
}
