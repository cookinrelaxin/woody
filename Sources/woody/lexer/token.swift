import Foundation

protocol Token
{
    var info           : TokenInfo    { get }

    func isEqualTo(_ other: Token) -> Bool
    var asEquatable: AnyToken { get }
}

extension Token
{
    func representation(in sourceLines: SourceLines) -> String
    {
        return sourceLines.string(in: info.startIndex ... info.endIndex)
    }

    func line(in sourceLines: SourceLines) -> String
    {
        return sourceLines.line(for: info.startIndex)
    }
}

extension Token where Self: Equatable
{
    func isEqualTo(_ other: Token) -> Bool
    {
        guard let other = other as? Self else { return false }
        return self == other
    }

    var asEquatable: AnyToken { return AnyToken(self) }
}

struct AnyToken
{
    init(_ token: Token) { self.token = token }

    fileprivate let token: Token
}

extension AnyToken: Equatable
{
    static func ==(lhs: AnyToken, rhs: AnyToken) -> Bool
    {
        return lhs.token.isEqualTo(rhs.token)
    }
}

struct TokenInfo: Equatable, Hashable, CustomDebugStringConvertible
{
    let startIndex     : SourceLines.Index
    let endIndex       : SourceLines.Index
    let sourceURL      : URL

    init(startIndex: SourceLines.Index,
         endIndex: SourceLines.Index,
         sourceURL: URL)
    {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.sourceURL = sourceURL
    }

    init(_ startIndex: (Int, Int),
         _ endIndex: (Int, Int),
         _ sourceURL: URL)
    {
        self.startIndex = SourceLines.Index(startIndex)
        self.endIndex = SourceLines.Index(endIndex)
        self.sourceURL = sourceURL
    }

    init(_ i: (Int, Int), _ s: URL) { self.init(i, i, s) }

    var debugDescription: Swift.String
    { return "(\(startIndex), \(endIndex))" }
}

extension Lexer
{
    struct Identifier: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct HelperDefinitionMarker: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct TokenDefinitionMarker: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct RuleTerminator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct GroupLeftDelimiter: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct GroupRightDelimiter: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct UnionOperator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct ZeroOrMoreOperator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct OneOrMoreOperator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct ZeroOrOneOperator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct String: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct SetMinus: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct Unicode: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct Character: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct RangeSeparator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct BracketedSetLeftDelimiter: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct BracketedSetRightDelimiter: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct SetSeparator: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }

    struct Erroneous: Token, Equatable, Hashable
    {
        let info: TokenInfo

        init(_ info: TokenInfo) { self.info = info }
    }
}
