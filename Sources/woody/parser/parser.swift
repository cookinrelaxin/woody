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

    private var expectedTokenStack: TokenClassStack

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
        catch let ParserError.expected(tokenClass)
        {
            expectedTokenStack.push(tokenClass)
            ParserError.printExpectationErrorMessage(expectedTokenStack,
                                                     try! nextToken(),
                                                     source)
            expectedTokenStack.clear()
        }

        return nil
    }

    init(lexer: Lexer)
    {
        tokens = lexer.tokens
        source = lexer.data
        expectedTokenStack = TokenClassStack()
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

        return .cat(rules)
    }

    func regex() throws -> Regex
    {
        let _dot = dot

        do { return .groupedRegex(try groupedRegex()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = Regex.ungroupedRegex(try ungroupedRegex())
        return n
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

        do { return .union(try union()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = UngroupedRegex.simpleRegex(try simpleRegex())
        return n
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

        do { return .concatenation(try concatenation()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = SimpleRegex.basicRegex(try basicRegex())
        return n
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

        do { return .string(try string()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        do { return .identifier(try identifier()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = ElementaryRegex.set(try set())
        return n
    }

    func definitionMarker() throws -> DefinitionMarker
    {
        let _dot = dot

        do { return .helperDefinitionMarker(try helperDefinitionMarker()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = DefinitionMarker.tokenDefinitionMarker(try tokenDefinitionMarker())
        return n
    }

    func repetitionOperator() throws -> RepetitionOperator
    {
        let _dot = dot

        do { return .zeroOrMoreOperator(try zeroOrMoreOperator()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        do { return .oneOrMoreOperator(try oneOrMoreOperator()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        dot = _dot

        let n = RepetitionOperator.zeroOrOneOperator(try zeroOrOneOperator())
        return n
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

        do { return .standardSet(try standardSet()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = SimpleSet.literalSet(try literalSet())
        return n
    }

    func standardSet() throws -> StandardSet
    {
        let _unicode = try unicode()

        return .cat(_unicode)
    }

    func literalSet() throws -> LiteralSet
    {
        let _dot = dot

        do { return .basicSet(try basicSet()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = LiteralSet.bracketedSet(try bracketedSet())
        return n
    }

    func basicSet() throws -> BasicSet
    {
        let _dot = dot

        do { return .range(try range()) }
        catch let ParserError.expected(expectedTokenClass)
        {
            expectedTokenStack.push(expectedTokenClass)
            dot = _dot
        }

        let n = BasicSet.character(try character())
        return n
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

        do
        {
            let n = try basicSets()
            return .basicSets(n)
        }
        catch let ParserError.expected(expectedTokenClass)
        { expectedTokenStack.push(expectedTokenClass) }

        dot = _dot

        let n = BasicSetList.basicSet(try basicSet())
        return n
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
