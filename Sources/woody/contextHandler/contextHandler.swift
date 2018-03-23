import Foundation

struct Context
{
    struct OrderedPRegex: Equatable, Hashable
    {
        let pRegex: ParseTree.Regex
        let order: Int

        init(_ pRegex: ParseTree.Regex, _ order: Int)
        {
            self.pRegex = pRegex
            self.order  = order
        }
    }

    typealias IDLookup = [String : Set<OrderedPRegex>]

    let idLookup: IDLookup
    let sourceLines: SourceLines
}
