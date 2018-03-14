import Foundation

final class Lexer
{
    fileprivate let data: String.UnicodeScalarView
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
}

fileprivate extension Lexer
{
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
            token = .helperDefinitionMarker(info(startDot))

        case "=" where data[nextDot] == ">":
            moveDot()
            token = .tokenDefinitionMarker(info(startDot))

        case ruleTerminator      : token = .ruleTerminator(info(startDot))
        case groupLeftDelimiter  : token = .groupLeftDelimiter(info(startDot))
        case groupRightDelimiter : token = .groupRightDelimiter(info(startDot))
        case unionOperator       : token = .unionOperator(info(startDot))
        case zeroOrMoreOperator  : token = .zeroOrMoreOperator(info(startDot))
        case oneOrMoreOperator   : token = .oneOrMoreOperator(info(startDot))
        case zeroOrOneOperator   : token = .zeroOrOneOperator(info(startDot))
        case lineHeadOperator    : token = .lineHeadOperator(info(startDot))
        case lineTailOperator    : token = .lineTailOperator(info(startDot))
        case stringDelimiter     : token = try recognizeString(startDot)
        case setMinus            : token = .setMinus(info(startDot))
        case setSeparator        : token = .setSeparator(info(startDot))
        case rangeSeparator      : token = .rangeSeparator(info(startDot))

        case bracketedSetLeftDelimiter:
            token = .bracketedSetLeftDelimiter(info(startDot))
        case bracketedSetRightDelimiter:
            token = .bracketedSetRightDelimiter(info(startDot))

        case characterLiteralMarker:
            moveDot()
            token = .character(info(startDot))

        default: token = .erroneous(info(startDot))
        }

        moveDot()

        return token
    }

    func info(_ startDot: Dot) -> TokenInfo
    { return TokenInfo(String(data[startDot...dot])) }

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

    func recognizeIdentifier(_ startDot: Dot) throws -> Token
    {
        while isIdentifierCharacter(try inputScalar()) { moveDot() }

        retractDot()

        return .identifier(info(startDot))
    }

    func recognizeCodepoint(_ startDot: Dot) throws -> Token
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

        return .character(info(startDot))
    }

    func recognizeString(_ startDot: Dot) throws -> Token
    {
        moveDot()

        while !isStringTerminator(try inputScalar()) { moveDot() }

        return .string(info(startDot))
    }

    func recognizeStandardSet(_ startDot: Dot) throws -> Token
    {
        return .unicode(info(startDot))
    }
}
