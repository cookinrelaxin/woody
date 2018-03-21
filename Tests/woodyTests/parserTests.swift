import XCTest
import Foundation
@testable import woody

fileprivate typealias RegularDescription = ParseTree.RegularDescription
fileprivate typealias Rule               = ParseTree.Rule
fileprivate typealias PossibleRules      = ParseTree.PossibleRules
fileprivate typealias Regex              = ParseTree.Regex
fileprivate typealias GroupedRegex       = ParseTree.GroupedRegex
fileprivate typealias UngroupedRegex     = ParseTree.UngroupedRegex
fileprivate typealias Union              = ParseTree.Union
fileprivate typealias SimpleRegex        = ParseTree.SimpleRegex
fileprivate typealias Concatenation      = ParseTree.Concatenation
fileprivate typealias BasicRegex         = ParseTree.BasicRegex
fileprivate typealias ElementaryRegex    = ParseTree.ElementaryRegex
fileprivate typealias DefinitionMarker   = ParseTree.DefinitionMarker
fileprivate typealias RepetitionOperator = ParseTree.RepetitionOperator
fileprivate typealias Set                = ParseTree.Set
fileprivate typealias SetSubtraction     = ParseTree.SetSubtraction
fileprivate typealias SimpleSet          = ParseTree.SimpleSet
fileprivate typealias StandardSet        = ParseTree.StandardSet
fileprivate typealias LiteralSet         = ParseTree.LiteralSet
fileprivate typealias BasicSet           = ParseTree.BasicSet
fileprivate typealias BracketedSet       = ParseTree.BracketedSet
fileprivate typealias BasicSetList       = ParseTree.BasicSetList
fileprivate typealias BasicSets          = ParseTree.BasicSets
fileprivate typealias Range              = ParseTree.Range

fileprivate typealias T = TokenInfo

class ParserTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testParseRule() throws
    {
        let url = URL(fileURLWithPath: "testParseRule.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()!
        let s = coordinator.reader.data

        let expectedParseTree = ParseTree(
            RegularDescription.cat(
                Rule.cat(
                    Identifier(T((0,0),(0,9),s)),
                    .tokenDefinitionMarker(
                        TokenDefinitionMarker(T((0,11),(0,12),s))),
                    Regex.ungroupedRegex(
                            UngroupedRegex.simpleRegex(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.identifier(
                                            Identifier(T((0,14),(0,28),s))),
                                        RepetitionOperator.oneOrMoreOperator(
                                            OneOrMoreOperator(T((0,29),(0,29),s))))))),
                    RuleTerminator(T((0,30),(0,30),s))),
                PossibleRules.cat(
                    [])))

        XCTAssertEqual(actualParseTree, expectedParseTree)
    }

    @available(macOS 10.11, *)
    func testParseMultipleRules() throws
    {
        let url = URL(fileURLWithPath: "testParseMultipleRules.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()!
        let s = coordinator.reader.data

let expectedParseTree = ParseTree(
RegularDescription.cat(
    Rule.cat(
        Identifier(T((1,0), (1,9),s)),
        DefinitionMarker.helperDefinitionMarker(
            HelperDefinitionMarker(T((1,12),(1,13),s))),
        Regex.ungroupedRegex(
            UngroupedRegex.simpleRegex(
                SimpleRegex.concatenation(
                    Concatenation.cat(
                        BasicRegex.cat(
                            ElementaryRegex.identifier(
                                Identifier(T((1,15),(1,29),s))),
                            nil),
                        SimpleRegex.basicRegex(
                            BasicRegex.cat(
                                ElementaryRegex.identifier(
                                    Identifier(T((1,31),(1,50),s))),
                                RepetitionOperator.zeroOrMoreOperator(
                                    ZeroOrMoreOperator(T((1,51),(1,51),s))))))))),
        RuleTerminator(T((1,52),(1,52),s))),
    PossibleRules.cat([
        Rule.cat(
            Identifier(T((3,0), (3,6),s)),
            DefinitionMarker.tokenDefinitionMarker(
                TokenDefinitionMarker(T((3,12),(3,13),s))),
            Regex.ungroupedRegex(
                UngroupedRegex.union(
                    Union.cat(
                        SimpleRegex.basicRegex(
                            BasicRegex.cat(
                                ElementaryRegex.identifier(
                                    Identifier(T((3,15),(3,33),s))),
                                nil)),
                        UnionOperator(T((3,35),(3,35),s)),
                        Regex.ungroupedRegex(
                            UngroupedRegex.union(
                                Union.cat(
                                    SimpleRegex.basicRegex(
                                        BasicRegex.cat(
                                            ElementaryRegex.identifier(
                                                Identifier(T((3,37), (3,53),s))),
                                            nil)),
                                UnionOperator(T((4,13),(4,13),s)),
                                Regex.ungroupedRegex(
                                    UngroupedRegex.simpleRegex(
                                        SimpleRegex.basicRegex(
                                            BasicRegex.cat(
                                                ElementaryRegex.identifier(
                                                    Identifier(T((4,15),(4,40),s))),
                                                nil)))))))))),
        RuleTerminator(T((4,41),(4,41),s)))])))

        XCTAssertEqual(actualParseTree, expectedParseTree)
    }

    @available(macOS 10.11, *)
    func testParseGroup() throws
    {
        let url = URL(fileURLWithPath: "testParseGroup.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()!
        let s = coordinator.reader.data

        let group2: GroupedRegex =
        GroupedRegex.cat(
            GroupLeftDelimiter(T((0,21),(0,21),s)),
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
                                                    Character(T((0,22),(0,23),s))))),
                                        nil)),
                                    nil),
                            SimpleRegex.basicRegex(
                                BasicRegex.cat(
                                    ElementaryRegex.identifier(
                                        Identifier(T((0,25),(0,27),s))),
                                    RepetitionOperator.oneOrMoreOperator(
                                        OneOrMoreOperator(T((0,28),(0,28),s))))))))),
            GroupRightDelimiter(T((0,29),(0,29),s)),
            RepetitionOperator.oneOrMoreOperator(
                OneOrMoreOperator(T((0,30),(0,30),s))))


let expectedParseTree = ParseTree(
RegularDescription.cat(
    Rule.cat(
        Identifier(T((0,0),(0,2),s)),
        .tokenDefinitionMarker(
            TokenDefinitionMarker(T((0,4),(0,5),s))),
        Regex.groupedRegex(
            GroupedRegex.cat(
                GroupLeftDelimiter(T((0,7),(0,7),s)),
                    Regex.ungroupedRegex(
                        UngroupedRegex.union(
                            Union.cat(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.string(
                                            String(T((0,8),(0,16),s))),
                                        RepetitionOperator.zeroOrOneOperator(
                                            ZeroOrOneOperator(T((0,17),(0,17),s))))),
                                UnionOperator(T((0,19),(0,19),s)),
                                Regex.groupedRegex(group2)))),
                GroupRightDelimiter(T((0,31),(0,31),s)),
                nil)),
        RuleTerminator(T((0,32),(0,32),s))),
    PossibleRules.cat(
        [])))

        XCTAssertEqual(actualParseTree, expectedParseTree)
    }

    @available(macOS 10.11, *)
    func testParseSet() throws
    {
        let url = URL(fileURLWithPath: "testParseSet.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualParseTree = try! coordinator.parser.parseTree()!
        let s = coordinator.reader.data

        let set1 =
        Set.cat(
            SimpleSet.standardSet(
                StandardSet.cat(
                    Unicode(T((0,8),s)))),
            SetSubtraction.cat(
                SetMinus(T((0,10),s)),
                SimpleSet.literalSet(
                    LiteralSet.bracketedSet(
                        BracketedSet.cat(
                            BracketedSetLeftDelimiter(T((0,12),s)),
                            BasicSetList.basicSets(
                                BasicSets.cat(
                                    BasicSet.range(
                                        Range.cat(
                                            Character(T((0,14),(0,15),s)),
                                            RangeSeparator(T((0,16),s)),
                                            Character(T((0,17),(0,18),s)))),
                                    SetSeparator(T((0,19),s)),
                                    BasicSetList.basicSets(
                                        BasicSets.cat(
                                            BasicSet.range(
                                                Range.cat(
                                                    Character(T((0,21),(0,22),s)),
                                                    RangeSeparator(T((0,23),s)),
                                                    Character(T((0,24),(0,25),s)))),
                                            SetSeparator(T((0,26),s)),
                                            BasicSetList.basicSet(
                                                BasicSet.range(
                                                    Range.cat(
                                                        Character(T((0,28),(0,32),s)),
                                                        RangeSeparator(T((0,33),s)),
                                                        Character(T((0,34),(0,38),s))))))))),
                            BracketedSetRightDelimiter(T((0,40),s)))))))

        let expectedParseTree = ParseTree(
        RegularDescription.cat(
            Rule.cat(
                Identifier(T((0,0),(0,2),s)),
                DefinitionMarker.helperDefinitionMarker(
                    HelperDefinitionMarker(T((0,4),(0,5),s))),
                Regex.groupedRegex(
                    GroupedRegex.cat(
                        GroupLeftDelimiter(T((0,7),s)),
                        Regex.ungroupedRegex(
                            UngroupedRegex.simpleRegex(
                                SimpleRegex.basicRegex(
                                    BasicRegex.cat(
                                        ElementaryRegex.set(
                                            set1),
                                        nil)))),
                        GroupRightDelimiter(T((0,41),s)),
                        RepetitionOperator.oneOrMoreOperator(
                            OneOrMoreOperator(T((0,42),s))))),
                RuleTerminator(T((0,43),s))),
            PossibleRules.cat(
                [])))

        XCTAssertEqual(actualParseTree, expectedParseTree)
    }

    @available(macOS 10.11, *)
    func testParseSwift()
    {
        let url = URL(fileURLWithPath: "swift.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        guard let parseTree = try! coordinator.parser.parseTree()
        else { XCTFail(); return }

        XCTAssertEqual(parseTree.flattened.count, 33)
    }
}
