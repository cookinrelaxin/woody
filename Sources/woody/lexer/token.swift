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

    var tokenClass: TokenClass
    {
        switch self
        {
        case is Lexer.Identifier:                 return .identifier
        case is Lexer.HelperDefinitionMarker:     return .helperDefinitionMarker
        case is Lexer.TokenDefinitionMarker:      return .tokenDefinitionMarker
        case is Lexer.RuleTerminator:             return .ruleTerminator
        case is Lexer.GroupLeftDelimiter:         return .groupLeftDelimiter
        case is Lexer.GroupRightDelimiter:        return .groupRightDelimiter
        case is Lexer.UnionOperator:              return .unionOperator
        case is Lexer.ZeroOrMoreOperator:         return .zeroOrMoreOperator
        case is Lexer.OneOrMoreOperator:          return .oneOrMoreOperator
        case is Lexer.ZeroOrOneOperator:          return .zeroOrOneOperator
        case is Lexer.String:                     return .string
        case is Lexer.SetMinus:                   return .setMinus
        case is Lexer.Unicode:                    return .unicode
        case is Lexer.Character:                  return .character
        case is Lexer.RangeSeparator:             return .rangeSeparator
        case is Lexer.BracketedSetLeftDelimiter:  return .bracketedSetLeftDelimiter
        case is Lexer.BracketedSetRightDelimiter: return .bracketedSetRightDelimiter
        case is Lexer.SetSeparator:               return .setSeparator
        default:                                  return .erroneous
        }
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

enum TokenClass: Hashable, Equatable, CustomDebugStringConvertible
{
    case identifier
    case helperDefinitionMarker
    case tokenDefinitionMarker
    case ruleTerminator
    case groupLeftDelimiter
    case groupRightDelimiter
    case unionOperator
    case zeroOrMoreOperator
    case oneOrMoreOperator
    case zeroOrOneOperator
    case string
    case setMinus
    case unicode
    case character
    case rangeSeparator
    case bracketedSetLeftDelimiter
    case bracketedSetRightDelimiter
    case setSeparator
    case erroneous

    var literal: String
    {
        switch self
        {
            case .identifier:                 return "e.g. `loop-statement`"
            case .helperDefinitionMarker:     return "i.e. `->`"
            case .tokenDefinitionMarker:      return "i.e. `=>`"
            case .ruleTerminator:             return "i.e. `;`"
            case .groupLeftDelimiter:         return "i.e. `(`"
            case .groupRightDelimiter:        return "i.e. `)`"
            case .unionOperator:              return "i.e. `|`"
            case .zeroOrMoreOperator:         return "i.e. `*`"
            case .oneOrMoreOperator:          return "i.e. `+`"
            case .zeroOrOneOperator:          return "i.e. `?`"
            case .string:                     return "e.g. `\"return\"`"
            case .setMinus:                   return "i.e. `\\"
            case .unicode:                    return "i.e. `U`"
            case .character:                  return "e.g. `'q`, `u0123`"
            case .rangeSeparator:             return "i.e. `-`"
            case .bracketedSetLeftDelimiter:  return "i.e. `{`"
            case .bracketedSetRightDelimiter: return "i.e. `}`"
            case .setSeparator:               return "i.e. `,`"
            case .erroneous:                  return "ERRONEOUS"
        }
    }

    var english: String
    {
        switch self
        {
            case .identifier:                 return "an identifier"
            case .helperDefinitionMarker:     return "a helper definition marker"
            case .tokenDefinitionMarker:      return "a token definition marker"
            case .ruleTerminator:             return "a rule terminator"
            case .groupLeftDelimiter:         return "a group left delimiter"
            case .groupRightDelimiter:        return "a group right delimiter"
            case .unionOperator:              return "a union operator"
            case .zeroOrMoreOperator:         return "a zero-or-more operator"
            case .oneOrMoreOperator:          return "a one-or-more operator"
            case .zeroOrOneOperator:          return "a zero-or-one operator"
            case .string:                     return "a string literal"
            case .setMinus:                   return "a set minus"
            case .unicode:                    return "the Unicode symbol"
            case .character:                  return "a character literal"
            case .rangeSeparator:             return "a range separator"
            case .bracketedSetLeftDelimiter:  return "a bracketed set left delimiter"
            case .bracketedSetRightDelimiter: return "a bracketed set right delimiter"
            case .setSeparator:               return "a set separator"
            case .erroneous:                  return "an erroneous token"
        }
    }

    var debugDescription: String
    {
        return "\(english) (\(literal))"
    }
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
