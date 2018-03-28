extension Parser
{
    func identifier() throws -> Lexer.Identifier
    {
        let token = try nextToken()

        guard let identifier = token as? Lexer.Identifier
        else { throw ParserError.expected(.identifier) }

        advanceDot()

        return identifier
    }

    func helperDefinitionMarker() throws -> Lexer.HelperDefinitionMarker
    {
        let token = try nextToken()

        guard let helperDefinitionMarker = token as? Lexer.HelperDefinitionMarker
        else { throw ParserError.expected(.helperDefinitionMarker) }

        advanceDot()

        return helperDefinitionMarker
    }

    func tokenDefinitionMarker() throws -> Lexer.TokenDefinitionMarker
    {
        let token = try nextToken()

        guard let tokenDefinitionMarker = token as? Lexer.TokenDefinitionMarker
        else { throw ParserError.expected(.tokenDefinitionMarker) }

        advanceDot()

        return tokenDefinitionMarker
    }

    func ruleTerminator() throws -> Lexer.RuleTerminator
    {
        let token = try nextToken()

        guard let ruleTerminator = token as? Lexer.RuleTerminator
        else { throw ParserError.expected(.ruleTerminator) }

        advanceDot()

        return ruleTerminator
    }

    func groupLeftDelimiter() throws -> Lexer.GroupLeftDelimiter
    {
        let token = try nextToken()

        guard let groupLeftDelimiter = token as? Lexer.GroupLeftDelimiter
        else { throw ParserError.expected(.groupLeftDelimiter) }

        advanceDot()

        return groupLeftDelimiter
    }

    func groupRightDelimiter() throws -> Lexer.GroupRightDelimiter
    {
        let token = try nextToken()

        guard let groupRightDelimiter = token as? Lexer.GroupRightDelimiter
        else { throw ParserError.expected(.groupRightDelimiter) }

        advanceDot()

        return groupRightDelimiter
    }

    func unionOperator() throws -> Lexer.UnionOperator
    {
        let token = try nextToken()

        guard let unionOperator = token as? Lexer.UnionOperator
        else { throw ParserError.expected(.unionOperator) }

        advanceDot()

        return unionOperator
    }

    func zeroOrMoreOperator() throws -> Lexer.ZeroOrMoreOperator
    {
        let token = try nextToken()

        guard let zeroOrMoreOperator = token as? Lexer.ZeroOrMoreOperator
        else { throw ParserError.expected(.zeroOrMoreOperator) }

        advanceDot()

        return zeroOrMoreOperator
    }

    func oneOrMoreOperator() throws -> Lexer.OneOrMoreOperator
    {
        let token = try nextToken()

        guard let oneOrMoreOperator = token as? Lexer.OneOrMoreOperator
        else { throw ParserError.expected(.oneOrMoreOperator) }

        advanceDot()

        return oneOrMoreOperator
    }

    func zeroOrOneOperator() throws -> Lexer.ZeroOrOneOperator
    {
        let token = try nextToken()

        guard let zeroOrOneOperator = token as? Lexer.ZeroOrOneOperator
        else { throw ParserError.expected(.zeroOrOneOperator) }

        advanceDot()

        return zeroOrOneOperator
    }

    func string() throws -> Lexer.String
    {
        let token = try nextToken()

        guard let string = token as? Lexer.String
        else { throw ParserError.expected(.string) }

        advanceDot()

        return string
    }

    func setMinus() throws -> Lexer.SetMinus
    {
        let token = try nextToken()

        guard let setMinus = token as? Lexer.SetMinus
        else { throw ParserError.expected(.setMinus) }

        advanceDot()

        return setMinus
    }

    func unicode() throws -> Lexer.Unicode
    {
        let token = try nextToken()

        guard let unicode = token as? Lexer.Unicode
        else { throw ParserError.expected(.unicode) }

        advanceDot()

        return unicode
    }

    func character() throws -> Lexer.Character
    {
        let token = try nextToken()

        guard let character = token as? Lexer.Character
        else { throw ParserError.expected(.character) }

        advanceDot()

        return character
    }

    func rangeSeparator() throws -> Lexer.RangeSeparator
    {
        let token = try nextToken()

        guard let rangeSeparator = token as? Lexer.RangeSeparator
        else { throw ParserError.expected(.rangeSeparator) }

        advanceDot()

        return rangeSeparator
    }

    func bracketedSetLeftDelimiter() throws -> Lexer.BracketedSetLeftDelimiter
    {
        let token = try nextToken()

        guard let bracketedSetLeftDelimiter = token as? Lexer.BracketedSetLeftDelimiter
        else { throw ParserError.expected(.bracketedSetLeftDelimiter) }

        advanceDot()

        return bracketedSetLeftDelimiter
    }

    func bracketedSetRightDelimiter() throws -> Lexer.BracketedSetRightDelimiter
    {
        let token = try nextToken()

        guard let bracketedSetRightDelimiter = token as? Lexer.BracketedSetRightDelimiter
        else { throw ParserError.expected(.bracketedSetRightDelimiter) }

        advanceDot()

        return bracketedSetRightDelimiter
    }

    func setSeparator() throws -> Lexer.SetSeparator
    {
        let token = try nextToken()

        guard let setSeparator = token as? Lexer.SetSeparator
        else { throw ParserError.expected(.setSeparator) }

        advanceDot()

        return setSeparator
    }
}
