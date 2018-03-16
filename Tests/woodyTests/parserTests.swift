import XCTest
@testable import woody

class ParserTests: XCTestCase
{
    func testParser() throws
    {
        let url = URL(fileURLWithPath: "./Tests/woodyTests/parser_test.woody")
        /*let url = URL(fileURLWithPath: "/Users/zacharyfeldcamp/iCloud
            * Drive/woody/Tests/woodyTests/parser_test.woody")*/
        let coordinator = PipelineCoordinator(url: url)

        /*print(coordinator.lexer.tokens)*/

        var actualParseTree: RegularDescription

        actualParseTree = try! coordinator.parser.parseTree()
        print(actualParseTree)

/*
 *        let expectedParseTree: RegularDescription =
 *        RegularDescription.cat(
 *            Rule.cat(
 *                Identifier("whitespace"),
 *                TokenDefinitionMarker("=>"),
 *                Regex.ungroupedRegex(
 *                        UngroupedRegex.simpleRegex(
 *                            SimpleRegex.basicRegex(
 *                                BasicRegex.cat(
 *                                    ElementaryRegex.identifier(
 *                                        Identifier("whitespace_item")),
 *                                    RepetitionOperator.oneOrMoreOperator(
 *                                        OneOrMoreOperator("+")))))),
 *                RuleTerminator(";")),
 *            PossibleRules.cat(
 *                []))
 *
 *        XCTAssertEqual(actualParseTree.asEquatable,
 *            expectedParseTree.asEquatable)
 */
    }
}
