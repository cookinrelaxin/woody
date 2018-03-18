import Foundation

typealias AST = AbstractSyntaxTree

// fileprivate func rules(for regularDescription: Parser.RegularDescription)
// {
//     var _rules = [Rule]()
//
//     switch regularDescription
//     {
//     case let .cat(rule, possibleRules):
//         _rules.append(rule)
//
//         switch possibleRules
//         {
//         case let .cat(actualRules):
//             _rules.append(contentsOf: actualRules)
//         }
//     }
//
//     return _rules
// }

struct AbstractSyntaxTree
{
    let tokenDefinitions: [TokenDefinition]

    init(for parseTree: Parser.ParseTree)
    {
        fatalError()
        // let regularDescription = parseTree.regularDescription
        // let _rules = rules(for: regularDescription)
        // var _tokenDefinitions = [TokenDefinition]()

        // for rule in _rules
        // {
        //     switch rule
        //     {
        //     case let .cat(id, definitionMarker, _, _):
        //         switch definitionMarker
        //         {
        //         case .helperDefinitionMarker(_): break
        //         case .tokenDefinitionMarker(_):
        //             if !_tokenDefinitions.contains
        //             { $0.identifier == id.representation }
        //             {
        //                 let _regex = regex(for: rule, in: regularDescription)
        //                 _tokenDefinitions.append(TokenDefinition(identifier: id,
        //                                                          regex: _regex))
        //             }
        //         }
        //     }
        // }

        // self.tokenDefinitions = _tokenDefinitions
    }

    /*init(rule: Rule)*/

    struct TokenDefinition
    {
        let identifier : String
        let regex      : Regex
    }

    indirect enum Regex
    {
        case union            (Regex, Regex)
        case concatenation    (Regex, Regex)
        case positionOperator (PositionOperator, RepetitionOperator?)
        case characterSet     (CharacterSet, RepetitionOperator?)
    }

    indirect enum RepetitionOperator: Nonterminal, Equatable
    {
        case zeroOrMore
        case oneOrMore
        case zeroOrOne
    }

    indirect enum PositionOperator: Nonterminal, Equatable
    {
        case lineHead
        case lineTail
    }

    struct CharacterSet
    {
        // private let ranges: Set<Range<Character>>

        // init(set: Set)
        // {
        //     fatalError()
        // }

        // init(set: Set<Range<Character>>)
        // {
        //     fatalError()
        // }
    }
}

/*
 *extension AbstractSyntaxTree: Equatable {}
 *
 *extension AST.Regex: Equatable
 *{
 *    [>lhs = rhs iff lhs ⊆ rhs ∧ rhs ⊆ lhs.<]
 *    static func ==(lhs: Regex, rhs: Regex)
 *    {
 *        switch lhs
 *        {
 *        case let .union(lhs_arg1, lhs_arg2):
 *        }
 *    }
 *}
 */
