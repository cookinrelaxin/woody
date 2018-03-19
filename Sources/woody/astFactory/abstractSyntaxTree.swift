import Foundation

typealias AST = AbstractSyntaxTree
typealias ParseTree = Parser.ParseTree

extension AST
{
    /*Turn the parse tree into a list of rules*/
    static func flatten(_ parseTree: ParseTree) -> [Parser.Rule]
    {
        var rules = [Parser.Rule]()

        switch parseTree.regularDescription
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

    static func abstract(_ identifierDict: [Identifier : Set<Parser.Regex>])
    throws -> [TokenDefinition]
    {
        var definitions = [Identifier : Regex]()
        var unhandledIdentifiers = identifierDict.keys

        func handleRegex(_ regex: Parser.Regex) -> Regex
        {
            let basicRegex: BasicRegex
            let repetitionOperator: RepetitionOperator?

            switch regex
            {
            case let .groupedRegex(groupedRegex):
                switch groupedRegex
                {
                case let .cat(_, _regex, _, _repetitionOperator):
                    basicRegex = handleUngroupedRegex(_regex)
                    repetitionOperator = _repetitionOperator
                }
            case let .ungroupedRegex(ungroupedRegex):
                basicRegex = handleUngroupedRegex(ungroupedRegex)
                repetitionOperator = nil
            }

            return Regex(basicRegex: basicRegex,
                         repetitionOperator: repetitionOperator)
        }

        func handleUngroupedRegex(_ ungroupedRegex: Parser.UngroupedRegex)
        -> BasicRegex
        {
            switch ungroupedRegex
            {
            case let .union(u):       return handleUnion(u)
            case let .simpleRegex(s): return handleSimpleRegex(s)
            }
        }

        func handleUnion(_ union: Parser.Union) -> BasicRegex
        {
            switch union
            {
            case let .cat(simpleRegex, _, regex):
                return BasicRegex.union(handleSimpleRegex(simpleRegex),
                                        handleRegex(regex))
            }
        }

        func handleSimpleRegex(_ simpleRegex: Parser.SimpleRegex) -> BasicRegex
        {
            switch simpleRegex
            {
            case let .concatenation(c) : return handleConcatenation(c)
            case let .basicRegex(b)    : return handleBasicRegex(b)
            }
        }

        func handleConcatenation(_ concatenation: Parser.Concatenation)
        -> BasicRegex
        {
            switch concatenation
            {
            case let .cat(b, s):
                return BasicRegex.concatenation(handleBasicRegex(b),
                                                handleSimpleRegex(s))
            }
        }

        func handleBasicRegex(_ basicRegex: Parser.BasicRegex) -> BasicRegex
        {
            switch basicRegex
            {
            case let .cat(elementaryRegex, repetitionOperator):
                switch elementaryRegex
                {
                case let string(s):
                    let b = handleString(s)
                case let identifier(i):
                case let set(s):
                }
            }
        }

        func handleElementaryRegex(_ elementaryRegex: Parser.ElementaryRegex) ->
        Regex
        {
        }

        func handleDefinitionMarker(_ definitionMarker: Parser.DefinitionMarker)
        -> Regex
        {
        }

        func handleRepetitionOperator(_ repetitionOperator:
            Parser.RepetitionOperator) -> Regex
        {
        }

        func handleSet(_ set: Parser.Set) -> Regex
        {
        }

        func handleSetSubtraction(_ setSubtraction: Parser.SetSubtraction) ->
        Regex
        {
        }

        func handleSimpleSet(_ simpleSet: Parser.SimpleSet) -> Regex
        {
        }

        func handleStandardSet(_ standardSet: Parser.StandardSet) -> Regex
        {
        }

        func handleLiteralSet(_ literalSet: Parser.LiteralSet) -> Regex
        {
        }

        func handleBasicSet(_ basicSet: Parser.BasicSet) -> Regex
        {
        }

        func handleBracketedSet(_ bracketedSet: Parser.BracketedSet) -> Regex
        {
        }

        func handleBasicSetList(_ basicSetList: Parser.BasicSetList) -> Regex
        {
        }

        func handleBasicSets(_ basicSets: Parser.BasicSets) -> Regex
        {
        }

        func handleRange(_ range: Parser.Range) -> Regex
        {
        }

        func handleIdentifier(_ id: Identifier)
        {
            let id            = rule.0

            for parserRegex in identifierDict[id]
            {
                if let index = definitions.index(ofKey: id)
                {
                    definitions[index] = Regex.union(definitions[index],
                                                     handleRegex(parserRegex))
                }
                else
                {
                    definitions[id] = handleRegex(parserRegex)
                }
            }
        }

        for id in identifierDict.keys
        {
            handleIdentifier(id)
        }
    }
}

struct AbstractSyntaxTree
{
    let rules: [Rule]

    struct Rule
    {
        let identifier : String
        let regex      : Regex
    }

    struct Regex
    {
        let basicRegex         : BasicRegex
        let repetitionOperator : RepetitionOperator?
    }

    indirect enum BasicRegex
    {
        case regex         (Regex)
        case epsilon
        case union         (Regex, Regex)
        case concatenation (Regex, Regex)
        case characterSet  (CharacterSet)
    }

    enum RepetitionOperator: Nonterminal, Equatable
    {
        case zeroOrMore
        case oneOrMore
        case zeroOrOne
    }

    struct CharacterSet
    {
        private let _ranges = Set<Range<Scalar>>
    }
}
