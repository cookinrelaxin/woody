import XCTest
import Foundation
@testable import woody

class ParserTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testParseRule() throws
    {
        let url = URL(fileURLWithPath: "testParseRule.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()

        let expectedParseTree: RegularDescription =
        RegularDescription.cat(
            Rule.cat(
                Identifier("whitespace"),
                .tokenDefinitionMarker(
                    TokenDefinitionMarker("=>")),
                Regex.ungroupedRegex(
                        UngroupedRegex.simpleRegex(
                            SimpleRegex.basicRegex(
                                BasicRegex.cat(
                                    ElementaryRegex.identifier(
                                        Identifier("whitespace_item")),
                                    RepetitionOperator.oneOrMoreOperator(
                                        OneOrMoreOperator("+")))))),
                RuleTerminator(";")),
            PossibleRules.cat(
                []))

        XCTAssertEqual(actualParseTree.asEquatable,
            expectedParseTree.asEquatable)
    }

    @available(macOS 10.11, *)
    func testParseMultipleRules() throws
    {
        let url = URL(fileURLWithPath: "testParseMultipleRules.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()

let expectedParseTree: RegularDescription =
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
        RuleTerminator(";"))]))

        XCTAssertEqual(actualParseTree.asEquatable,
            expectedParseTree.asEquatable)
    }

    @available(macOS 10.11, *)
    func testParseGroup() throws
    {
        let url = URL(fileURLWithPath: "testParseGroup.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()

        let group2: GroupedRegex =
        GroupedRegex.cat(
            GroupLeftDelimiter("("),
            Regex.ungroupedRegex(
                UngroupedRegex.simpleRegex(
                    SimpleRegex.concatenation(
                        Concatenation.cat(
                            BasicRegex.cat(
                                ElementaryRegex.set(
                                    Set.cat(
                                        SimpleSet.literalSet(
                                            LiteralSet.basicSet(
                                                BasicSet.character(
                                                    Character("'.")))),
                                        nil)),
                                    nil),
                            SimpleRegex.basicRegex(
                                BasicRegex.cat(
                                    ElementaryRegex.identifier(
                                        Identifier("nt1")),
                                    RepetitionOperator.oneOrMoreOperator(
                                        OneOrMoreOperator("+")))))))),
            GroupRightDelimiter(")"),
            RepetitionOperator.oneOrMoreOperator(
                OneOrMoreOperator("+")))


let expectedParseTree: RegularDescription =
RegularDescription.cat(
    Rule.cat(
        Identifier("nt1"),
        .tokenDefinitionMarker(
            TokenDefinitionMarker("=>")),
        Regex.groupedRegex(
            GroupedRegex.cat(
                GroupLeftDelimiter("("),
                    Regex.ungroupedRegex(
                        UngroupedRegex.union(
                            Union.cat(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.string(
                                            String("\"heyo  !\"")),
                                        RepetitionOperator.zeroOrOneOperator(
                                            ZeroOrOneOperator("?")))),
                                UnionOperator("|"),
                                Regex.groupedRegex(group2)))),
                GroupRightDelimiter(")"),
                nil)),
        RuleTerminator(";")),
    PossibleRules.cat(
        []))

        XCTAssertEqual(actualParseTree.asEquatable,
            expectedParseTree.asEquatable)
    }

    @available(macOS 10.11, *)
    func testParseSet() throws
    {
        let url = URL(fileURLWithPath: "testParseSet.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()

        let set1 =
        Set.cat(
            SimpleSet.standardSet(
                StandardSet.cat(
                    Unicode("U"))),
            SetSubtraction.cat(
                SetMinus("\\"),
                SimpleSet.literalSet(
                    LiteralSet.bracketedSet(
                        BracketedSet.cat(
                            BracketedSetLeftDelimiter("{"),
                            BasicSetList.basicSets(
                                BasicSets.cat(
                                    BasicSet.range(
                                        Range.cat(
                                            Character("'a"),
                                            RangeSeparator("-"),
                                            Character("'z"))),
                                    SetSeparator(","),
                                    BasicSetList.basicSets(
                                        BasicSets.cat(
                                            BasicSet.range(
                                                Range.cat(
                                                    Character("'A"),
                                                    RangeSeparator("-"),
                                                    Character("'Z"))),
                                            SetSeparator(","),
                                            BasicSetList.basicSet(
                                                BasicSet.range(
                                                    Range.cat(
                                                        Character("u0030"),
                                                        RangeSeparator("-"),
                                                        Character("u0039")))))))),
                            BracketedSetRightDelimiter("}"))))))

        let expectedParseTree: RegularDescription =
        RegularDescription.cat(
            Rule.cat(
                Identifier("id1"),
                DefinitionMarker.helperDefinitionMarker(
                    HelperDefinitionMarker("->")),
                Regex.groupedRegex(
                    GroupedRegex.cat(
                        GroupLeftDelimiter("("),
                        Regex.ungroupedRegex(
                            UngroupedRegex.simpleRegex(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.set(
                                            set1),
                                        nil)))),
                        GroupRightDelimiter(")"),
                        RepetitionOperator.oneOrMoreOperator(
                            OneOrMoreOperator("+")))),
                RuleTerminator(";")),
            PossibleRules.cat(
                []))

        XCTAssertEqual(actualParseTree.asEquatable,
            expectedParseTree.asEquatable)
    }
}
