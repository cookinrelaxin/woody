import Foundation

protocol UnionMappable: Sequence
{
    associatedtype Element

    func unionMap<T>(_ closure: (Element) -> T) -> Set<T>
    func unionMap<T>(_ closure: (Element) -> Set<T>) -> Set<T>
}

extension UnionMappable
{
    func unionMap<T>(_ closure: (Element) -> T) -> Set<T>
    { return reduce(Set<T>()) { set, e in set.union([closure(e)]) } }

    func unionMap<T>(_ closure: (Element) -> Set<T>) -> Set<T>
    { return reduce(Set<T>()) { set, e in set.union(closure(e)) } }
}

extension Set
{
    mutating func pop() -> Element?
    {
        if isEmpty { return nil }
        return removeFirst()
    }
}

extension Set
{
    func union<T>() -> Set<T>
    where Element == Set<T>
    {
        var s = Set<T>()

        for e in self { s.formUnion(e) }

        return s
    }
}

extension Set   : UnionMappable {}
extension Array : UnionMappable {}

extension Collection
{
    var isNotEmpty: Bool { return !isEmpty }
}
