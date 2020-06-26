import Foundation

protocol DateSortable: Comparable {
    var datePosted: Date { get }
}

extension DateSortable {
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
