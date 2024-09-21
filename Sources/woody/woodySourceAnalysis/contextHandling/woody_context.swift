import Foundation

struct WoodyContext
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
    let boundIdentifiers: Set<String>

    init(for parseTree: WoodyParseTree)
    {
        self.idLookup = makeIDLookup(for: parseTree)
        self.boundIdentifiers = []
    }

    private func makeIDLookup(for parseTree: WoodyParseTree) -> IDLookup
    {
        return parseTree.flattened.enumerated().reduce(IDLookup())
        { dict, pair in
            let (i, pRule) = pair
            var _dict = dict

            switch pRule
            {
            case let .cat(id, _, pRegex, _):
                let key = id.representation
                if let s = _dict[key]
                {
                    let order = s.first!.order
                    _dict[key] = s.union([OrderedPRegex(pRegex, order)])
                }
                else { _dict[key] = [OrderedPRegex(pRegex, i)] }
            }

            return _dict
        }
    }
}
