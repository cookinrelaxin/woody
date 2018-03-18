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

    static func removeDuplicates(_ rules: [Parser.Rule]) -> [Parser.Rule]
    {
        var _rules = [Parser.Rule]()

        for rule in rules { if !_rules.contains(rule) { _rules.append(rule) } }

        return _rules
    }

    /*
     Transform `rules` into a semantically identical list of rules such that
     each identifier reference in an `ElementaryRegex` is replaced with its
     referent `Parser.Regex`. Note that it is possible that we may encounter a
     reference cycle. But this is an exception, since recursive token
     definitions are forbidden by the specification.
     */
    static func replaceIdentifierReferences(in rules: [Parser.Rule]) throws
    -> [Parser.Rule]
    {
        var identifierDefinitions = [String : TokenDefinition]()

        func handleRegex(_ regex: Parser.Regex) throws
        {
            switch regex
            {
            case let .groupedRegex(groupedRegex):
                try handleGroupedRegex(groupedRegex)
            case let .ungroupedRegex(ungroupedRegex):
                try handleUngroupedRegex(ungroupedRegex)
            }
        }

        func handleGroupedRegex(_ groupedRegex: Parser.GroupedRegex) throws
        {
        }

        func handleUngroupedRegex(_ ungroupedRegex: Parser.UngroupedRegex)
        throws
        {
        }

        func handleUnion(_ union: Parser.Union) throws
        {
        }

        func handleSimpleRegex(_ simpleRegex: Parser.SimpleRegex) throws
        {
        }

        func handleConcatenation(_ concatenation: Parser.Concatenation) throws
        {
        }

        func handleBasicRegex(_ basicRegex: Parser.BasicRegex)
        throws
        {
        }

        func handleElementaryRegex(_ elementaryRegex: Parser.ElementaryRegex)
        throws
        {
        }

        func handleDefinitionMarker(_ definitionMarker: Parser.DefinitionMarker)
        throws
        {
        }

        func handleRepetitionOperator(_ repetitionOperator:
            Parser.RepetitionOperator) throws
        {
        }

        func handlePositionOperator(_ positionOperator: Parser.PositionOperator)
        throws
        {
        }

        func handleSet(_ set: Parser.Set) throws
        {
        }

        func handleSetSubtraction(_ setSubtraction: Parser.SetSubtraction) throws
        {
        }

        func handleSimpleSet(_ simpleSet: Parser.SimpleSet) throws
        {
        }

        func handleStandardSet(_ standardSet: Parser.StandardSet)
        throws
        {
        }

        func handleLiteralSet(_ literalSet: Parser.LiteralSet)
        throws
        {
        }

        func handleBasicSet(_ basicSet: Parser.BasicSet) throws
        {
        }

        func handleBracketedSet(_ bracketedSet: Parser.BracketedSet)
        throws
        {
        }

        func handleBasicSetList(_ basicSetList: Parser.BasicSetList)
        throws
        {
        }

        func handleBasicSets(_ basicSets: Parser.BasicSets) throws
        {
        }

        func handleRange(_ range: Parser.Range) throws
        {
        }

        for rule in rules
        {
            switch rule
            {
            case let .cat(id, _, regex, _):
                identifierDefinitions[id.representation] = regex
            }
        }

        for regex in identifierDefinitions.values
        {
            try handleRegex(regex)
        }

        fatalError()
    }

    static func union(rule1: Parser.Rule, rule2: Parser.Rule) -> Parser.Rule
    {
        fatalError()

        // let rule             : Parser.Rule
        // let id               : Lexer.Identifier
        // let definitionMarker : Lexer.DefinitionMarker
        // let ruleTerminator   : Lexer.RuleTerminator

        // switch (rule1, rule2)
        // {
        // case let (.cat(id1, m1, _, t1), .cat(id2, m2, _, t2)):
        //     precondition(id1 == id2 && m1 == m2 && t1 == t2)
        //     id = id1; definitionMarker = m1; ruleTerminator = t1;
        // }

        // return rule
    }

    /*
     *Turn multiple definitions of the same nonterminal into a single definition
     *of union form. So `rules` becomes a semantically identical list of rules
     *where each nonterminal is defined exactly once.
     */
    static func unionize(_ rules: [Parser.Rule]) -> [Parser.Rule]
    {
        fatalError()
    }

    /*
     *Transform `literalDict` into a semantically identical list of token definitions.
     */
    static func abstract(_ literalDict: [Identifier : Set<Parser.Regex>]) throws
    -> [TokenDefinition]
    {
        var tokenDict = [Identifier : Regex]()
        var unhandledLiteralPairs = literalPairs

        for (id, literalRegex) in unhandledLiteralPairs
        {
            if let index = tokenDict.index(forKey: id)
            {
                let existingRegex = tokenDict[index]
                let newRegex = handleRegex(literalRegex)

                tokenDict[index] = formUnion(existingRegex, newRegex)
            }
            else
            {
                tokenDict[id] = handleRegex(literalRegex)
            }
        }
    }
}

struct AbstractSyntaxTree
{
    let tokenDefinitions: [TokenDefinition]

    struct TokenDefinition
    {
        let identifier : String
        let regex      : Regex
    }

    indirect enum Regex
    {
        case union            (Regex, Regex)
        case concatenation    (Regex, Regex)
        case positionOperator (PositionOperator, RepetitionOperator?)
        case characterSet     (CharacterSet, RepetitionOperator?)
    }

    indirect enum RepetitionOperator: Nonterminal, Equatable
    {
        case zeroOrMore
        case oneOrMore
        case zeroOrOne
    }

    indirect enum PositionOperator: Nonterminal, Equatable
    {
        case lineHead
        case lineTail
    }

    struct CharacterSet
    {
        // private let ranges: Set<Range<Character>>

        // init(set: Set)
        // {
        //     fatalError()
        // }

        // init(set: Set<Range<Character>>)
        // {
        //     fatalError()
        // }
    }
}

/*
 *extension AbstractSyntaxTree: Equatable {}
 *
 *extension AST.Regex: Equatable
 *{
 *    [>lhs = rhs iff lhs ⊆ rhs ∧ rhs ⊆ lhs.<]
 *    static func ==(lhs: Regex, rhs: Regex)
 *    {
 *        switch lhs
 *        {
 *        case let .union(lhs_arg1, lhs_arg2):
 *        }
 *    }
 *}
 */
