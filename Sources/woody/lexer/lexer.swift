import Foundation

final class Lexer
{
    fileprivate let data: Swift.String.UnicodeScalarView
    fileprivate var dot: Dot

    var previousDot: Dot { return data.index(before: dot) }
    var nextDot: Dot     { return data.index(after: dot) }
    var nextNextDot: Dot { return data.index(after: nextDot) }

    func retractDot() { dot = previousDot }
    func moveDot()    { dot = nextDot }

    fileprivate func inputScalar() throws -> Scalar
    {
        guard dot < data.endIndex else { throw LexerError.endOfInput }

        return data[dot]
    }

    lazy var tokens: [Token] =
    {
        var tokens: [Token] = []

        while let token = try? nextToken() { tokens.append(token) }

        return tokens
    }()

    init?(reader: Reader)
    {
        guard let data = reader.data else { return nil }

        self.data = data
        dot = data.startIndex
    }

    func nextToken() throws -> Token
    {
        try skipInsignificant()

        /*noteTokenPosition()*/

        let startDot    : Index  = dot
        let inputScalar : Scalar = data[dot]
        let token       : Token

        switch inputScalar
        {
        case hexPrefix where isHexDigit(data[nextDot]):
            token = try recognizeCodepoint(startDot)

        case let s where isIdentifierHead(s):
            token = try recognizeIdentifier(startDot)

        case let s where isStandardSetHead(s):
            token = try recognizeStandardSet(startDot)

        case "-" where data[nextDot] == ">":
            moveDot()
            token = HelperDefinitionMarker(info(startDot))

        case "=" where data[nextDot] == ">":
            moveDot()
            token = TokenDefinitionMarker(info(startDot))

        case ruleTerminator      : token = RuleTerminator(info(startDot))
        case groupLeftDelimiter  : token = GroupLeftDelimiter(info(startDot))
        case groupRightDelimiter : token = GroupRightDelimiter(info(startDot))
        case unionOperator       : token = UnionOperator(info(startDot))
        case zeroOrMoreOperator  : token = ZeroOrMoreOperator(info(startDot))
        case oneOrMoreOperator   : token = OneOrMoreOperator(info(startDot))
        case zeroOrOneOperator   : token = ZeroOrOneOperator(info(startDot))
        case lineHeadOperator    : token = LineHeadOperator(info(startDot))
        case lineTailOperator    : token = LineTailOperator(info(startDot))
        case stringDelimiter     : token = try recognizeString(startDot)
        case setMinus            : token = SetMinus(info(startDot))
        case setSeparator        : token = SetSeparator(info(startDot))
        case rangeSeparator      : token = RangeSeparator(info(startDot))

        case bracketedSetLeftDelimiter:
            token = BracketedSetLeftDelimiter(info(startDot))
        case bracketedSetRightDelimiter:
            token = BracketedSetRightDelimiter(info(startDot))

        case characterLiteralMarker:
            moveDot()
            token = Character(info(startDot))

        default: token = Erroneous(info(startDot))
        }

        moveDot()

        return token
    }
}

fileprivate extension Lexer
{
    func info(_ startDot: Dot) -> Swift.String
    { return Swift.String(data[startDot...dot]) }

    func skipWhitespace() throws
    {
        while isWhitespace(try inputScalar())
        {
            moveDot()
        }
    }

    func skipInsignificant() throws
    {
        try skipWhitespace()

        while try inputScalar() == commentMarker
        {
            moveDot()

            while !isLinebreak(try inputScalar())
            {
                moveDot()
            }

            moveDot()

            try skipWhitespace()
        }
    }

    func recognizeIdentifier(_ startDot: Dot) throws -> Identifier
    {
        while isIdentifierCharacter(try inputScalar()) { moveDot() }

        retractDot()

        return Identifier(info(startDot))
    }

    func recognizeCodepoint(_ startDot: Dot) throws -> Character
    {
        moveDot()

        for _ in 0..<6
        {
            if !isHexDigit(try inputScalar())
            {
                retractDot()
                break
            }

            moveDot()
        }

        return Character(info(startDot))
    }

    func recognizeString(_ startDot: Dot) throws -> String
    {
        moveDot()

        while !isStringTerminator(try inputScalar()) { moveDot() }

        return String(info(startDot))
    }

    func recognizeStandardSet(_ startDot: Dot) throws -> Unicode
    {
        return Unicode(info(startDot))
    }
}
