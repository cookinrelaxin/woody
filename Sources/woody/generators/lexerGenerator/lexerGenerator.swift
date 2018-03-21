import Foundation

typealias Code = String

final class LexerGenerator
{
    let ast: AbstractSyntaxTree

    // lazy var tokenClassDefinitions: Code =
    // {
    //     let rules = _orderedRules(for: regularDescription)
    //     let tokenClasses = _orderedTokenClasses(for: rules)
    //     let formattedClassNames = _formattedClassNames(for: tokenClasses)

    //     return _tokenClassDefinitions(for: formattedClassNames)
    // }()

    init(ast: AbstractSyntaxTree)
    { self.ast = ast }

    // func generateLexer() -> Code
    // {
    //     fatalError()
    // }
}


// func _stateDefinitions() -> Code
// {
//     fatalError()
// }
//
// func _transitionTable() -> Code
// {
//     fatalError()
// }
//
// fileprivate func _tokenClassDefinitions(for tokenClasses: [Swift.String]) -> Code
// {
//     var definitions: Swift.String = ""
//
//     for tokenClass in tokenClasses
//     {
//         let definition = """
//         struct \(tokenClass): Token, Equatable {
//             let representation: String
//
//             init(_ representation: String)
//             { self.representation = representation }
//         }
//
//
//         """
//
//         definitions.append(definition)
//     }
//
//     definitions.removeLast()
//
//     return definitions
// }
//
// fileprivate func _formattedClassNames(for tokenClasses: [Swift.String])
// -> [Swift.String]
// {
//     return tokenClasses.map { $0.prefix(1).uppercased() + $0.dropFirst() }
// }
//
// fileprivate func _orderedTokenClasses(for rules: [Rule]) -> [Swift.String]
// {
//     return rules.reduce([Swift.String]()) { tokenClasses, rule in
//         switch rule
//         {
//         case let .cat(id, definitionMarker, _, _):
//             var newTokenClasses = tokenClasses
//
//             switch definitionMarker
//             {
//             case .helperDefinitionMarker(_): break
//             case .tokenDefinitionMarker(_):
//                 let rep = id.representation
//                 if !tokenClasses.contains(rep) { newTokenClasses.append(rep) }
//             }
//
//             return newTokenClasses
//         }
//     }
// }
//
// fileprivate func _orderedRules(for regularDescription: RegularDescription)
// -> [Rule]
// {
//     let rules: [Rule]
//
//     switch regularDescription
//     {
//     case let .cat(rule, possibleRules):
//         switch possibleRules
//         {
//             case let .cat(actualRules):
//                 var _rules = [Rule]()
//
//                 _rules.append(rule)
//                 _rules.append(contentsOf: actualRules)
//
//                 rules = _rules
//         }
//     }
//
//     return rules
// }
