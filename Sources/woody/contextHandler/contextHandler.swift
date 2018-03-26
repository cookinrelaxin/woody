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
    let boundIdentifiers: Set<String>

    init(idLookup: IDLookup, sourceLines: SourceLines, boundIdentifiers:
        Set<String>)
    {
        self.idLookup = idLookup
        self.sourceLines = sourceLines
        self.boundIdentifiers = boundIdentifiers
    }

    init(_ context: Context, _ identifier: String)
    {
        idLookup = context.idLookup
        sourceLines = context.sourceLines
        boundIdentifiers = context.boundIdentifiers.union([identifier])
    }
}
