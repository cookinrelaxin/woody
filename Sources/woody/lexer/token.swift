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

struct Identifier: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension Identifier: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(identifier \(representation))"
    }
}

struct HelperDefinitionMarker: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension HelperDefinitionMarker: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(helperDefinitionMarker \(representation))"
    }
}

struct TokenDefinitionMarker: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension TokenDefinitionMarker: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(tokenDefinitionMarker \(representation))"
    }
}

struct RuleTerminator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension RuleTerminator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(ruleTerminator \(representation))"
    }
}

struct GroupLeftDelimiter: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension GroupLeftDelimiter: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(groupLeftDelimiter \(representation))"
    }
}

struct GroupRightDelimiter: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension GroupRightDelimiter: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(groupRightDelimiter \(representation))"
    }
}

struct UnionOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension UnionOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(unionOperator \(representation))"
    }
}

struct ZeroOrMoreOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension ZeroOrMoreOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(zeroOrMoreOperator \(representation))"
    }
}

struct OneOrMoreOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension OneOrMoreOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(oneOrMoreOperator \(representation))"
    }
}

struct ZeroOrOneOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension ZeroOrOneOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(zeroOrOneOperator \(representation))"
    }
}

struct LineHeadOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension LineHeadOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(lineHeadOperator \(representation))"
    }
}

struct LineTailOperator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension LineTailOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(lineTailOperator \(representation))"
    }
}

struct String: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension String: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(string \(representation))"
    }
}

struct SetMinus: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension SetMinus: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(setMinus \(representation))"
    }
}

struct Unicode: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension Unicode: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(unicode \(representation))"
    }
}

struct Character: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension Character: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(character \(representation))"
    }
}

struct RangeSeparator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension RangeSeparator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(rangeSeparator \(representation))"
    }
}

struct BracketedSetLeftDelimiter: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension BracketedSetLeftDelimiter: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(bracketedSetLeftDelimiter \(representation))"
    }
}

struct BracketedSetRightDelimiter: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension BracketedSetRightDelimiter: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(bracketedSetRightDelimiter \(representation))"
    }
}

struct SetSeparator: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension SetSeparator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(setSeparator \(representation))"
    }
}

struct Erroneous: Token, Equatable
{
    let representation: Swift.String

    init(_ representation: Swift.String)
    { self.representation = representation }

    func print(_ indentation: Swift.String) -> Swift.String { return indentation+debugDescription }
}

extension Erroneous: CustomDebugStringConvertible
{
    var debugDescription: Swift.String
    {
        return "(erroneous \(representation))"
    }
}
