import Foundation

fileprivate typealias RegularDescription = ParseTree.RegularDescription
fileprivate typealias Rule               = ParseTree.Rule
fileprivate typealias PossibleRules      = ParseTree.PossibleRules
fileprivate typealias Regex              = ParseTree.Regex
fileprivate typealias GroupedRegex       = ParseTree.GroupedRegex
fileprivate typealias UngroupedRegex     = ParseTree.UngroupedRegex
fileprivate typealias Union              = ParseTree.Union
fileprivate typealias SimpleRegex        = ParseTree.SimpleRegex
fileprivate typealias Concatenation      = ParseTree.Concatenation
fileprivate typealias BasicRegex         = ParseTree.BasicRegex
fileprivate typealias ElementaryRegex    = ParseTree.ElementaryRegex
fileprivate typealias DefinitionMarker   = ParseTree.DefinitionMarker
fileprivate typealias RepetitionOperator = ParseTree.RepetitionOperator
fileprivate typealias Set                = ParseTree.Set
fileprivate typealias SetSubtraction     = ParseTree.SetSubtraction
fileprivate typealias SimpleSet          = ParseTree.SimpleSet
fileprivate typealias StandardSet        = ParseTree.StandardSet
fileprivate typealias LiteralSet         = ParseTree.LiteralSet
fileprivate typealias BasicSet           = ParseTree.BasicSet
fileprivate typealias BracketedSet       = ParseTree.BracketedSet
fileprivate typealias BasicSetList       = ParseTree.BasicSetList
fileprivate typealias BasicSets          = ParseTree.BasicSets
fileprivate typealias Range              = ParseTree.Range

final class Parser
{
    private var tokens: [Token]
    private var source: SourceLines
    fileprivate var dot = 0

    func nextToken() throws -> Token
    {
        guard dot < tokens.endIndex else { throw ParserError.unexpectedEndOfInput }

        return tokens[dot]
    }

    func advanceDot()
    {
        dot += 1
    }

    func parseTree() throws -> ParseTree?
    {
        do
        {
            let _regularDescription = try regularDescription()
            return ParseTree(_regularDescription)
        }
        catch let ParserError.expectedIdentifier(token)
        {
            ParserError.printExpectationErrorMessage("Identifier", token, source)
        }
        catch let ParserError.expectedHelperDefinitionMarker(token)
        {
            ParserError.printExpectationErrorMessage("HelperDefinitionMarker",
                token, source)
        }
        catch let ParserError.expectedTokenDefinitionMarker(token)
        {
            ParserError.printExpectationErrorMessage("TokenDefinitionMarker",
                token, source)
        }
        catch let ParserError.expectedRuleTerminator(token)
        {
            ParserError.printExpectationErrorMessage("RuleTerminator", token,
                source)
        }
        catch let ParserError.expectedGroupLeftDelimiter(token)
        {
            ParserError.printExpectationErrorMessage("GroupLeftDelimiter",
                token, source)
        }
        catch let ParserError.expectedGroupRightDelimiter(token)
        {
            ParserError.printExpectationErrorMessage("GroupRightDelimiter",
                token, source)
        }
        catch let ParserError.expectedUnionOperator(token)
        {
            ParserError.printExpectationErrorMessage("UnionOperator", token,
                source)
        }
        catch let ParserError.expectedZeroOrMoreOperator(token)
        {
            ParserError.printExpectationErrorMessage("ZeroOrMoreOperator",
                token, source)
        }
        catch let ParserError.expectedOneOrMoreOperator(token)
        {
            ParserError.printExpectationErrorMessage("OneOrMoreOperator", token,
   source)
        }
        catch let ParserError.expectedZeroOrOneOperator(token)
        {
            ParserError.printExpectationErrorMessage("ZeroOrOneOperator", token,
   source)
        }
        catch let ParserError.expectedString(token)
        {
            ParserError.printExpectationErrorMessage("String", token, source)
        }
        catch let ParserError.expectedSetMinus(token)
        {
            ParserError.printExpectationErrorMessage("SetMinus", token, source)
        }
        catch let ParserError.expectedUnicode(token)
        {
            ParserError.printExpectationErrorMessage("Unicode", token, source)
        }
        catch let ParserError.expectedCharacter(token)
        {
            ParserError.printExpectationErrorMessage("Character", token, source)
        }
        catch let ParserError.expectedRangeSeparator(token)
        {
            ParserError.printExpectationErrorMessage("RangeSeparator", token,
                source)
        }
        catch let ParserError.expectedBracketedSetLeftDelimiter(token)
        {
            ParserError.printExpectationErrorMessage("BracketedSetLeftDelimiter",
                token, source)
        }
        catch let ParserError.expectedBracketedSetRightDelimiter(token)
        {
            ParserError.printExpectationErrorMessage("BracketedSetRightDelimiter",
                token, source)
        }
        catch let ParserError.expectedSetSeparator(token)
        {
            ParserError.printExpectationErrorMessage("SetSeparator", token,
                source)
        }
        // catch ParserError.unexpectedEndOfInput
        // {
        // }

        return nil
    }

    init(lexer: Lexer)
    {
        tokens = lexer.tokens
        source = lexer.data
    }
}

fileprivate extension Parser
{
    func regularDescription() throws -> RegularDescription
    {
        let _rule          = try rule()
        let _possibleRules = try possibleRules()

        return .cat(_rule, _possibleRules)
    }

    func rule() throws -> Rule
    {
        let _identifier            = try identifier()
        let _definitionMarker      = try definitionMarker()
        let _regex                 = try regex()
        let _ruleTerminator        = try ruleTerminator()

        return .cat(_identifier, _definitionMarker, _regex, _ruleTerminator)
    }

    func possibleRules() throws -> PossibleRules
    {
        var rules = [Rule]()
        while dot < tokens.endIndex { rules.append(try rule()) }
        /*while let r = try? rule() { rules.append(r) }*/

        return .cat(rules)
    }

    func regex() throws -> Regex
    {
        let _dot = dot

        if let g = try? groupedRegex() { return .groupedRegex(g) }

        dot = _dot

        return .ungroupedRegex(try ungroupedRegex())
    }

    func groupedRegex() throws -> GroupedRegex
    {
        let _groupLeftDelimiter  = try groupLeftDelimiter()
        let _regex               = try regex()
        let _groupRightDelimiter = try groupRightDelimiter()
        let _repetitionOperator  = try? repetitionOperator()

        return .cat(_groupLeftDelimiter, _regex, _groupRightDelimiter,
            _repetitionOperator)
    }

    func ungroupedRegex() throws -> UngroupedRegex
    {
        let _dot = dot

        if let u = try? union() { return .union(u) }

        dot = _dot

        return .simpleRegex(try simpleRegex())
    }

    func union() throws -> Union
    {
        let _simpleRegex   = try simpleRegex()
        let _unionOperator = try unionOperator()
        let _regex         = try regex()

        return .cat(_simpleRegex, _unionOperator, _regex)
    }

    func simpleRegex() throws -> SimpleRegex
    {
        let _dot = dot

        if let c = try? concatenation() { return .concatenation(c) }

        dot = _dot

        return .basicRegex(try basicRegex())
    }

    func concatenation() throws -> Concatenation
    {
        let _basicRegex  = try basicRegex()
        let _simpleRegex = try simpleRegex()

        return .cat(_basicRegex, _simpleRegex)
    }

    func basicRegex() throws -> BasicRegex
    {
        let _elementaryRegex    = try elementaryRegex()
        let _repetitionOperator = try? repetitionOperator()

        return .cat(_elementaryRegex, _repetitionOperator)
    }

    func elementaryRegex() throws -> ElementaryRegex
    {

        let _dot = dot

        if let n = try? string() { return .string(n) }

        dot = _dot

        if let n = try? identifier() { return .identifier(n) }

        dot = _dot

        return .set(try set())
    }

    func definitionMarker() throws -> DefinitionMarker
    {
        let _dot = dot

        if let n = try? helperDefinitionMarker() { return
            .helperDefinitionMarker(n) }

        dot = _dot

        return .tokenDefinitionMarker(try tokenDefinitionMarker())
    }

    func repetitionOperator() throws -> RepetitionOperator
    {
        let _dot = dot

        if let n = try? zeroOrMoreOperator() { return .zeroOrMoreOperator(n) }

        dot = _dot

        if let n = try? oneOrMoreOperator() { return .oneOrMoreOperator(n) }

        dot = _dot

        return .zeroOrOneOperator(try zeroOrOneOperator())
    }

    func set() throws -> Set
    {
        let _simpleSet      = try simpleSet()
        let _setSubtraction = try? setSubtraction()

        return .cat(_simpleSet, _setSubtraction)
    }

    func setSubtraction() throws -> SetSubtraction
    {
        let _setMinus  = try setMinus()
        let _simpleSet = try simpleSet()

        return .cat(_setMinus, _simpleSet)
    }

    func simpleSet() throws -> SimpleSet
    {
        let _dot = dot

        if let n = try? standardSet() { return .standardSet(n) }

        dot = _dot

        return .literalSet(try literalSet())
    }

    func standardSet() throws -> StandardSet
    {
        let _unicode = try unicode()

        return .cat(_unicode)
    }

    func literalSet() throws -> LiteralSet
    {
        let _dot = dot

        if let n = try? basicSet() { return .basicSet(n) }

        dot = _dot

        return .bracketedSet(try bracketedSet())
    }

    func basicSet() throws -> BasicSet
    {
        let _dot = dot

        if let n = try? range() { return .range(n) }

        dot = _dot

        return .character(try character())
    }

    func bracketedSet() throws -> BracketedSet
    {
        let _bracketedSetLeftDelimiter  = try bracketedSetLeftDelimiter()
        let _basicSetList               = try basicSetList()
        let _bracketedSetRightDelimiter = try bracketedSetRightDelimiter()

        return .cat(_bracketedSetLeftDelimiter, _basicSetList,
            _bracketedSetRightDelimiter)
    }

    func basicSetList() throws -> BasicSetList
    {
        let _dot = dot

        if let n = try? basicSets() { return .basicSets(n) }

        dot = _dot

        return .basicSet(try basicSet())
    }

    func basicSets() throws -> BasicSets
    {
        let _basicSet     = try basicSet()
        let _setSeparator = try setSeparator()
        let _basicSetList = try basicSetList()

        return .cat(_basicSet, _setSeparator, _basicSetList)
    }

    func range() throws -> Range
    {
        let _character_1    = try character()
        let _rangeSeparator = try rangeSeparator()
        let _character_2    = try character()

        return .cat(_character_1, _rangeSeparator, _character_2)
    }

}
