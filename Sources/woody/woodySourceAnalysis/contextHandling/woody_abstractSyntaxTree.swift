import Foundation

typealias AST = AbstractSyntaxTree

fileprivate func toScalar(_ lCharacter: Lexer.Character) -> Scalar
{
    let s = lCharacter.representation
    switch (s.first!)
    {
    case "u":
        return Scalar(UInt32(s.dropFirst(), radix: 16)!)!

    case "'":
        return s.dropFirst().unicodeScalars.first!

    default: fatalError()
    }
}

extension ParseTree
{
    var flattened: [Rule]
    {
        var rules = [Rule]()

        switch regularDescription
        {
        case let .cat(rule, possibleRules):
            rules.append(rule)

            switch possibleRules
            {
            case let .cat(actualRules):
                rules.append(contentsOf: actualRules)
            }
        }

        return rules
    }

    static func unique(in rules: [Rule]) -> [Rule]
    {
        return rules.reduce([Rule]())
        { _rules, rule in
            var a = _rules

            switch rule
            { case let .cat(id1, d, _, _):
                switch d
                { case .helperDefinitionMarker(_): break
                  case .tokenDefinitionMarker(_):
                      if !_rules.contains
                      { r in
                          switch r
                          {
                          case let .cat(id2,_,_,_):
                              return id1.representation == id2.representation
                          }
                      }
                      { a.append(rule) }
                }
            }

            return a
        }
    }
}

struct WoodyAbstractSyntaxTree: Equatable, Hashable
{
    typealias OrderedPRegex = Context.OrderedPRegex

    let rules: [TokenDefinition]

    var hashValue: Int { return rules.count }

    init(parseTree: ParseTree, sourceLines: SourceLines)
    {
        let pRules: [ParseTree.Rule] = parseTree.flattened

        let idLookup = pRules.enumerated().reduce(Context.IDLookup())
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

        let context = Context(idLookup: idLookup,
                              sourceLines: sourceLines,
                              boundIdentifiers: [])

        var rules = [TokenDefinition]()

        do
        {
            rules = try ParseTree.unique(in: pRules)
                             .map { try TokenDefinition(pRule: $0, context) }
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
