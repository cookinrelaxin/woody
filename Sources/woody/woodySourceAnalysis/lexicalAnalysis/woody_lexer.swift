import Foundation

final class WoodyLexicalAnalyzer
{
    typealias Dot = SourceLines.Index

    let data     : SourceLines
    var startDot : Dot
    var dot      : Dot

    var previousDot : Dot { return data.index(before: dot) }
    var nextDot     : Dot { return data.index(after: dot) }
    var nextNextDot : Dot { return data.index(after: nextDot) }

    func retractDot() { dot = previousDot }
    func moveDot()    { dot = nextDot }

    var info: TokenInfo
    { return TokenInfo(startIndex: startDot, endIndex: dot, source: data) }

    func inputScalar() throws -> Scalar
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

    init(reader: Reader)
    {
        data     = reader.data
        startDot = data.startIndex
        dot      = data.startIndex
    }

    func nextToken() throws -> Token
    {
        try skipInsignificant()

        startDot = dot

        let inputScalar : Scalar = data[dot]
        let token       : Token

        switch inputScalar
        {
        case hexPrefix where isHexDigit(data[nextDot]):
            token = try recognizeCodepoint()

        case let s where isIdentifierHead(s):
            token = try recognizeIdentifier()

        case let s where isStandardSetHead(s):
            token = try recognizeStandardSet()

        case "-" where data[nextDot] == ">":
            moveDot()
            token = HelperDefinitionMarker(info)

        case "=" where data[nextDot] == ">":
            moveDot()
            token = TokenDefinitionMarker(info)

        case ruleTerminator      : token = RuleTerminator(info)
        case groupLeftDelimiter  : token = GroupLeftDelimiter(info)
        case groupRightDelimiter : token = GroupRightDelimiter(info)
        case unionOperator       : token = UnionOperator(info)
        case zeroOrMoreOperator  : token = ZeroOrMoreOperator(info)
        case oneOrMoreOperator   : token = OneOrMoreOperator(info)
        case zeroOrOneOperator   : token = ZeroOrOneOperator(info)
        case stringDelimiter     : token = try recognizeString()
        case setMinus            : token = SetMinus(info)
        case setSeparator        : token = SetSeparator(info)
        case rangeSeparator      : token = RangeSeparator(info)

        case bracketedSetLeftDelimiter:
            token = BracketedSetLeftDelimiter(info)
        case bracketedSetRightDelimiter:
            token = BracketedSetRightDelimiter(info)

        case characterLiteralMarker:
            moveDot()
            token = Character(info)

        default: token = Erroneous(info)
        }

        moveDot()

        return token
    }
}

fileprivate extension Lexer
{
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

    func recognizeIdentifier() throws -> Identifier
    {
        while isIdentifierCharacter(try inputScalar()) { moveDot() }

        retractDot()

        return Identifier(info)
    }

    func recognizeCodepoint() throws -> Character
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

        return Character(info)
    }

    func recognizeString() throws -> String
    {
        moveDot()

        while !isStringTerminator(try inputScalar()) { moveDot() }

        return String(info)
    }

    func recognizeStandardSet() throws -> Unicode
    {
        return Unicode(info)
    }
}
