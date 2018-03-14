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
        case "u" where isHexDigit(data[nextDot]):
            token = try recognizeCodepoint(startDot)

        case let s where isIdentifierHead(s):
            token = try recognizeIdentifier(startDot)

        case "-" where data[nextDot] == ">":
            moveDot()
            token = .helperArrow(info(startDot))

        case "=" where data[nextDot] == ">":
            moveDot()
            token = .tokenArrow(info(startDot))

        case ";" : token = .semicolon(info(startDot))
        case "(" : token = .leftParenthesis(info(startDot))
        case ")" : token = .rightParenthesis(info(startDot))
        case "|" : token = .bar(info(startDot))
        case "*" : token = .star(info(startDot))
        case "+" : token = .plus(info(startDot))
        case "?" : token = .question(info(startDot))
        case "^" : token = .caret(info(startDot))
        case "$" : token = .dollar(info(startDot))

        case "\"":
            token = try recognizeString(startDot)

        case "'":
            moveDot()
            token = .character(info(startDot))

        case "{" : token = .leftBracket(info(startDot))
        case "}" : token = .rightBracket(info(startDot))

        case "," : token = .setSeparator(info(startDot))

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

        while try inputScalar() == hash
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

    func recognizeString(_ startDot: Dot) -> Token
    {
        while !isStringTerminator(try inputScalar()) { moveDot() }

        return .string(info(startDot))
    }
}
