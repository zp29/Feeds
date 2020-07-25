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

extension Post {
    static var placeholder: Post {
        Post(
            id: UUID().description,
            // FIXME: Make this a local placeholder image
            avatar: URL(staticString: "https://scontent-dfw5-1.cdninstagram.com/v/t51.2885-19/s320x320/12080424_280912232240122_678835955_a.jpg?_nc_ht=scontent-dfw5-1.cdninstagram.com&_nc_ohc=9uSnxvBP1FMAX8yLvgt&oh=df760f6d918180ef2e850eca4ee13d80&oe=5F2C945D"),
            displayName: "Neven Mrgan",
            username: "@sardinebrunch",
            // FIXME: Make the service image redact too
            service: "instagram",
            // TODO: Randomize which ones have media
            media: [],
            title: "Chicken!",
            body: "Tempura chicken tenders, Old Bay seasoned. Plus fries, homemade zucchini pickles, and a sauce of mayo + homemade smoked apricot BBQ sauce. Pic 2 is like 1/3 of the total amount I fried. Tempura is cool because it’s way simpler to batter with it than to bother with 3 different bowls, and it leaves the fry oil totally clean.",
            datePosted: Date(),
            shareURL: URL(staticString: "https://instagram.com/sardinebrunch")
        )
    }
    
    static var demo: Post {
        Post(
            id: UUID().description,
            avatar: URL(staticString: "https://scontent-dfw5-1.cdninstagram.com/v/t51.2885-19/s320x320/12080424_280912232240122_678835955_a.jpg?_nc_ht=scontent-dfw5-1.cdninstagram.com&_nc_ohc=9uSnxvBP1FMAX8yLvgt&oh=df760f6d918180ef2e850eca4ee13d80&oe=5F2C945D"),
            displayName: "Neven Mrgan",
            username: "@sardinebrunch",
            service: "instagram",
            media: [
                Post.Media(
                    source: URL(staticString: "https://scontent-dfw5-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/106495441_3063061667134461_2989484783314130514_n.jpg?_nc_ht=scontent-dfw5-1.cdninstagram.com&_nc_cat=109&_nc_ohc=MTDihLpID_sAX___QiL&oh=0425f9f2ca66016e804cac3cf578b5ed&oe=5F2DC39F"),
                    isVideo: false
                )
            ],
            title: "Chicken!",
            body: "Tempura chicken tenders, Old Bay seasoned. Plus fries, homemade zucchini pickles, and a sauce of mayo + homemade smoked apricot BBQ sauce. Pic 2 is like 1/3 of the total amount I fried. Tempura is cool because it’s way simpler to batter with it than to bother with 3 different bowls, and it leaves the fry oil totally clean.",
            datePosted: Date(),
            shareURL: URL(staticString: "https://instagram.com/sardinebrunch")
        )
    }
}
