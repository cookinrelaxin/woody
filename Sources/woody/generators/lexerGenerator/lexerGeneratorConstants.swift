import Foundation

// extension LexerGenerator
// {
//     fileprivate _lexerInterface = """
//         import Foundation
//
//         final class Lexer
//         {
//             lazy var tokens: [Token] =
//             {
//                 fatalError()
//             }()
//
//             init?(reader: Reader)
//             {
//                 fatalError()
//             }
//
//             func nextToken() throws -> Token
//             {
//                 fatalError()
//             }
//         }
//         """
//
//     fileprivate let _errorDefinitions = """
//         TODO
//         """
//
//     fileprivate let _tokenProtocol = """
//         protocol Token
//         {
//             var representation: Swift.String { get }
//
//             func isEqualTo(_ other: Token) -> Bool
//             var asEquatable: AnyToken { get }
//         }
//
//         extension Token where Self: Equatable
//         {
//             func isEqualTo(_ other: Token) -> Bool
//             {
//                 guard let other = other as? Self else { return false }
//                 return self == other
//             }
//
//             var asEquatable: AnyToken { return AnyToken(self) }
//         }
//
//         struct AnyToken
//         {
//             init(_ token: Token) { self.token = token }
//
//             fileprivate let token: Token
//         }
//
//         extension AnyToken: Equatable
//         {
//             static func ==(lhs: AnyToken, rhs: AnyToken) -> Bool
//             {
//                 return lhs.token.isEqualTo(rhs.token)
//             }
//         }
//         """
// }
