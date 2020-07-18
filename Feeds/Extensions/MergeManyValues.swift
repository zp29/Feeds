import Combine

extension Publishers {
    func MergeManyValues<T>(_ values: [T]) -> MergeMany<Just<T>> {
        MergeMany(values.map { Just($0) })
    }
    
    func MergeManyValues<T>(_ values: T...) -> MergeMany<Just<T>> {
        MergeMany(values.map { Just($0) })
    }
}
