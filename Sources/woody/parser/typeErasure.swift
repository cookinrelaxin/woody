import Foundation

protocol Nonterminal
{
    func isEqualTo(_ other: Nonterminal) -> Bool
    var asEquatable: AnyNonterminal { get }
}

extension Nonterminal where Self: Equatable
{
    func isEqualTo(_ other: Nonterminal) -> Bool
    {
        guard let other = other as? Self else { return false }
        return self == other
    }

    var asEquatable: AnyNonterminal { return AnyNonterminal(self) }
}

struct AnyNonterminal
{
    init(_ nonterminal: Nonterminal) { self.nonterminal = nonterminal }

    fileprivate let nonterminal: Nonterminal
}

extension AnyNonterminal: Equatable
{
    static func ==(lhs: AnyNonterminal, rhs: AnyNonterminal) -> Bool
    {
        return lhs.nonterminal.isEqualTo(rhs.nonterminal)
    }
}
