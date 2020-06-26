extension Array where Element: Equatable {
    func removingDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
    
    func appending(contentsOf newElements: [Element]) -> [Element] {
        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}
