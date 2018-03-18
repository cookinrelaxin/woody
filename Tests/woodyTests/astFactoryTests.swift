import XCTest
import Foundation
@testable import woody

fileprivate typealias ParseTree = Parser.ParseTree

fileprivate typealias RegularDescription = Parser.RegularDescription
fileprivate typealias Rule               = Parser.Rule
fileprivate typealias PossibleRules      = Parser.PossibleRules
fileprivate typealias Regex              = Parser.Regex
fileprivate typealias GroupedRegex       = Parser.GroupedRegex
fileprivate typealias UngroupedRegex     = Parser.UngroupedRegex
fileprivate typealias Union              = Parser.Union
fileprivate typealias SimpleRegex        = Parser.SimpleRegex
fileprivate typealias Concatenation      = Parser.Concatenation
fileprivate typealias BasicRegex         = Parser.BasicRegex
fileprivate typealias ElementaryRegex    = Parser.ElementaryRegex
fileprivate typealias DefinitionMarker   = Parser.DefinitionMarker
fileprivate typealias RepetitionOperator = Parser.RepetitionOperator
fileprivate typealias PositionOperator   = Parser.PositionOperator
fileprivate typealias Set                = Parser.Set
fileprivate typealias SetSubtraction     = Parser.SetSubtraction
fileprivate typealias SimpleSet          = Parser.SimpleSet
fileprivate typealias StandardSet        = Parser.StandardSet
fileprivate typealias LiteralSet         = Parser.LiteralSet
fileprivate typealias BasicSet           = Parser.BasicSet
fileprivate typealias BracketedSet       = Parser.BracketedSet
fileprivate typealias BasicSetList       = Parser.BasicSetList
fileprivate typealias BasicSets          = Parser.BasicSets
fileprivate typealias Range              = Parser.Range

class ASTFactoryTests: XCTestCase
{
    func testFlatten()
    {

let parseTree = ParseTree(
RegularDescription.cat(
    Rule.cat(
        Identifier("identifier"),
        DefinitionMarker.helperDefinitionMarker(
            HelperDefinitionMarker("->")),
        Regex.ungroupedRegex(
            UngroupedRegex.simpleRegex(
                SimpleRegex.concatenation(
                    Concatenation.cat(
                        BasicRegex.cat(
                            ElementaryRegex.identifier(
                                Identifier("identifier_head")),
                            nil),
                        SimpleRegex.basicRegex(
                            BasicRegex.cat(
                                ElementaryRegex.identifier(
                                    Identifier("identifier_character")),
                                RepetitionOperator.zeroOrMoreOperator(
                                    ZeroOrMoreOperator("*")))))))),
        RuleTerminator(";")),
    PossibleRules.cat([
        Rule.cat(
            Identifier("keyword"),
            DefinitionMarker.tokenDefinitionMarker(
                TokenDefinitionMarker("=>")),
            Regex.ungroupedRegex(
                UngroupedRegex.union(
                    Union.cat(
                        SimpleRegex.basicRegex(
                            BasicRegex.cat(
                                ElementaryRegex.identifier(
                                    Identifier("declaration_keyword")),
                                nil)),
                        UnionOperator("|"),
                        Regex.ungroupedRegex(
                            UngroupedRegex.union(
                                Union.cat(
                                    SimpleRegex.basicRegex(
                                        BasicRegex.cat(
                                            ElementaryRegex.identifier(
                                                Identifier("statement_keyword")),
                                            nil)),
                                UnionOperator("|"),
                                Regex.ungroupedRegex(
                                    UngroupedRegex.simpleRegex(
                                        SimpleRegex.basicRegex(
                                            BasicRegex.cat(
                                                ElementaryRegex.identifier(
                                                    Identifier("expression_or_type_keyword")),
                                                nil)))))))))),
        RuleTerminator(";"))])))

        let expectedRules: [Parser.Rule] =
        [
            Rule.cat(
                Identifier("identifier"),
                DefinitionMarker.helperDefinitionMarker(
                    HelperDefinitionMarker("->")),
                Regex.ungroupedRegex(
                    UngroupedRegex.simpleRegex(
                        SimpleRegex.concatenation(
                            Concatenation.cat(
                                BasicRegex.cat(
                                    ElementaryRegex.identifier(
                                        Identifier("identifier_head")),
                                    nil),
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.identifier(
                                            Identifier("identifier_character")),
                                        RepetitionOperator.zeroOrMoreOperator(
                                            ZeroOrMoreOperator("*")))))))),
                RuleTerminator(";")),
                Rule.cat(
                    Identifier("keyword"),
                    DefinitionMarker.tokenDefinitionMarker(
                        TokenDefinitionMarker("=>")),
                    Regex.ungroupedRegex(
                        UngroupedRegex.union(
                            Union.cat(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.identifier(
                                            Identifier("declaration_keyword")),
                                        nil)),
                                UnionOperator("|"),
                                Regex.ungroupedRegex(
                                    UngroupedRegex.union(
                                        Union.cat(
                                            SimpleRegex.basicRegex(
                                                BasicRegex.cat(
                                                    ElementaryRegex.identifier(
                                                        Identifier("statement_keyword")),
                                                    nil)),
                                        UnionOperator("|"),
                                        Regex.ungroupedRegex(
                                            UngroupedRegex.simpleRegex(
                                                SimpleRegex.basicRegex(
                                                    BasicRegex.cat(
                                                        ElementaryRegex.identifier(
                                                            Identifier("expression_or_type_keyword")),
                                                        nil)))))))))),
                RuleTerminator(";"))
        ]

        let actualRules = AST.flatten(parseTree)

        XCTAssertEqual(actualRules, expectedRules)
    }
}
