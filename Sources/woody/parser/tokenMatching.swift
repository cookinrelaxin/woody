extension Parser
{
    func identifier() throws -> Identifier
    {
        let token = try nextToken()

        guard let identifier = token as? Identifier
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return identifier
    }

    func helperDefinitionMarker() throws -> HelperDefinitionMarker
    {
        let token = try nextToken()

        guard let helperDefinitionMarker = token as? HelperDefinitionMarker
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return helperDefinitionMarker
    }

    func tokenDefinitionMarker() throws -> TokenDefinitionMarker
    {
        let token = try nextToken()

        guard let tokenDefinitionMarker = token as? TokenDefinitionMarker
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return tokenDefinitionMarker
    }

    func ruleTerminator() throws -> RuleTerminator
    {
        let token = try nextToken()

        guard let ruleTerminator = token as? RuleTerminator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return ruleTerminator
    }

    func groupLeftDelimiter() throws -> GroupLeftDelimiter
    {
        let token = try nextToken()

        guard let groupLeftDelimiter = token as? GroupLeftDelimiter
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return groupLeftDelimiter
    }

    func groupRightDelimiter() throws -> GroupRightDelimiter
    {
        let token = try nextToken()

        guard let groupRightDelimiter = token as? GroupRightDelimiter
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return groupRightDelimiter
    }

    func unionOperator() throws -> UnionOperator
    {
        let token = try nextToken()

        guard let unionOperator = token as? UnionOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return unionOperator
    }

    func zeroOrMoreOperator() throws -> ZeroOrMoreOperator
    {
        let token = try nextToken()

        guard let zeroOrMoreOperator = token as? ZeroOrMoreOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return zeroOrMoreOperator
    }

    func oneOrMoreOperator() throws -> OneOrMoreOperator
    {
        let token = try nextToken()

        guard let oneOrMoreOperator = token as? OneOrMoreOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return oneOrMoreOperator
    }

    func zeroOrOneOperator() throws -> ZeroOrOneOperator
    {
        let token = try nextToken()

        guard let zeroOrOneOperator = token as? ZeroOrOneOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return zeroOrOneOperator
    }

    func lineHeadOperator() throws -> LineHeadOperator
    {
        let token = try nextToken()

        guard let lineHeadOperator = token as? LineHeadOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return lineHeadOperator
    }

    func lineTailOperator() throws -> LineTailOperator
    {
        let token = try nextToken()

        guard let lineTailOperator = token as? LineTailOperator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return lineTailOperator
    }

    func string() throws -> String
    {
        let token = try nextToken()

        guard let string = token as? String
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return string
    }

    func setMinus() throws -> SetMinus
    {
        let token = try nextToken()

        guard let setMinus = token as? SetMinus
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return setMinus
    }

    func unicode() throws -> Unicode
    {
        let token = try nextToken()

        guard let unicode = token as? Unicode
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return unicode
    }

    func character() throws -> Character
    {
        let token = try nextToken()

        guard let character = token as? Character
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return character
    }

    func rangeSeparator() throws -> RangeSeparator
    {
        let token = try nextToken()

        guard let rangeSeparator = token as? RangeSeparator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return rangeSeparator
    }

    func bracketedSetLeftDelimiter() throws -> BracketedSetLeftDelimiter
    {
        let token = try nextToken()

        guard let bracketedSetLeftDelimiter = token as? BracketedSetLeftDelimiter
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return bracketedSetLeftDelimiter
    }

    func bracketedSetRightDelimiter() throws -> BracketedSetRightDelimiter
    {
        let token = try nextToken()

        guard let bracketedSetRightDelimiter = token as? BracketedSetRightDelimiter
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return bracketedSetRightDelimiter
    }

    func setSeparator() throws -> SetSeparator
    {
        let token = try nextToken()

        guard let setSeparator = token as? SetSeparator
        else { throw ParserError.unexpectedToken(token) }

        advanceDot()

        return setSeparator
    }

}
