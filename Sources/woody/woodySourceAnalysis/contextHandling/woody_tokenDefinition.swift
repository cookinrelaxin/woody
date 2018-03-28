import Foundation

struct TokenDefinition: Equatable, Hashable
{
    let tokenClass : String
    let order      : Int
    let regex      : Regex

    init(_ tokenClass: String, _ order: Int, _ regex: Regex)
    {
        self.tokenClass = tokenClass
        self.order      = order
        self.regex      = regex
    }

    init(pRule: ParseTree.Rule, _ context: Context) throws
    {
        switch pRule
        {
        case let .cat(id, _, pRegex, _):
            self.tokenClass = String(id.representation)
            guard let orderedPRegex = context.idLookup[tokenClass]
            else { throw ContextHandlingError.undefinedIdentifier(id) }

            self.order      = orderedPRegex.first!.order

            let newContext = Context(context, id.representation)
            try self.regex  = Regex(pRegex: pRegex, newContext)
        }
    }
}
