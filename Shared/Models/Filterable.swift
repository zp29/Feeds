protocol KeywordFilterable {
    func contains(keyword: String) -> Bool
}

extension KeywordFilterable {
    func contains(keywords: [String]) -> Bool {
        for keyword in keywords {
            if contains(keyword: keyword) { return true }
        }
        
        return false
    }
}

protocol UsernameFilterable {
    func wasPostedBy(username: String) -> Bool
}

typealias Filterable = KeywordFilterable & UsernameFilterable
