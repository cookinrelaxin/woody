import Foundation

protocol Token
{
    var representation: Swift.String { get }

    func isEqualTo(_ other: Token) -> Bool
    var asEquatable: AnyToken { get }
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

extension Lexer
{
    struct Identifier: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct HelperDefinitionMarker: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct TokenDefinitionMarker: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct RuleTerminator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct GroupLeftDelimiter: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct GroupRightDelimiter: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct UnionOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct ZeroOrMoreOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct OneOrMoreOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct ZeroOrOneOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct LineHeadOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct LineTailOperator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct String: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct SetMinus: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct Unicode: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct Character: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct RangeSeparator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct BracketedSetLeftDelimiter: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct BracketedSetRightDelimiter: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct SetSeparator: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }


    struct Erroneous: Token, Equatable
    {
        let representation: Swift.String

        init(_ representation: Swift.String)
        { self.representation = representation }

    }

}
