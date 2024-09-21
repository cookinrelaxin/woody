import Foundation

struct RegularDescription: Equatable, Hashable
{
    typealias OrderedPRegex = Context.OrderedPRegex

    let tokenDefinitions: [TokenDefinition]

    var hashValue: Int { return rules.count }

    init(parseTree: ParseTree, sourceLines: SourceLines)
    {
        var tokenDefinitions = [TokenDefinition]()
        let context = Context(for: parseTree)

        do
        {
            tokenDefinitions = try parseTree.flattened.map
            { try TokenDefinition(pRule: $0, context) }
        }
        catch let ContextHandlingError.undefinedIdentifier(id)
        {
            ContextHandlingError.print(.undefinedIdentifier(id), context)
            exit(1)
        }
        catch let ContextHandlingError.recursiveTokenDefinition(id)
        {
            ContextHandlingError.print(.recursiveTokenDefinition(id), context)
            exit(1)
        }
        catch let e
        {
            print("Unexpected error in astFactory: \(e)")
            exit(1)
        }

        self.rules = rules
    }
}

extension RegularDescription: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let i = indentation+standardIndentation
        let rulesSexp = rules.reduce("")
        { $0 + "\($1.sexp(i))" + "\n" }

        let sexp = indentation+"""
        (ast
        \(rulesSexp))
        """

        return sexp
    }
}
