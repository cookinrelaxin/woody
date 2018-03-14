import XCTest
@testable import woody

class woodyTests: XCTestCase
{
    func testExample()
    {
        let url = URL(fileURLWithPath: "./Tests/woodyTests/swift.woody")
        let coordinator = PipelineCoordinator(url: url)

        let actualTokens = coordinator.lexer.tokens
        /*print(actualTokens)*/

        let expectedTokens: [Token] =
        [
            .identifier(TokenInfo("whitespace")),
            .tokenArrow(TokenInfo("=>")),
            .identifier(TokenInfo("whitespace_item")),
            .plus(TokenInfo("+")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("identifier")),
            .tokenArrow(TokenInfo("=>")),
            .identifier(TokenInfo("identifier_head")),
            .identifier(TokenInfo("identifier_character")),
            .star(TokenInfo("*")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("keyword")),
            .tokenArrow(TokenInfo("=>")),
            .identifier(TokenInfo("declaration_keyword")),
            .bar(TokenInfo("|")),
            .identifier(TokenInfo("statement_keyword")),
            .bar(TokenInfo("|")),
            .identifier(TokenInfo("expression_or_type_keyword")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("punctuation")),
            .tokenArrow(TokenInfo("=>")),
            .character(TokenInfo("'(")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("')")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("'{")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("'}")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("'[")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("']")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("'.")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("',")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("':")),
            .bar(TokenInfo("|")),
            .character(TokenInfo("';")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("whitespace")),
            .tokenArrow(TokenInfo("=>")),
            .identifier(TokenInfo("whitespace_item")),
            .plus(TokenInfo("+")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("whitespace_item")),
            .helperArrow(TokenInfo("->")),
            .identifier(TokenInfo("line_break")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("whitespace_item")),
            .helperArrow(TokenInfo("->")),
            .identifier(TokenInfo("comment")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("whitespace_item")),
            .helperArrow(TokenInfo("->")),
            .identifier(TokenInfo("multiline_comment")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("whitespace_item")),
            .helperArrow(TokenInfo("->")),
            .leftBracket(TokenInfo("{")),
            .character(TokenInfo("u0000")),
            .setSeparator(TokenInfo(",")),
            .character(TokenInfo("u0009")),
            .setSeparator(TokenInfo(",")),
            .character(TokenInfo("u000B")),
            .setSeparator(TokenInfo(",")),
            .character(TokenInfo("u000C")),
            .setSeparator(TokenInfo(",")),
            .character(TokenInfo("u0020")),
            .rightBracket(TokenInfo("}")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("line_break")),
            .helperArrow(TokenInfo("->")),
            .character(TokenInfo("u000A")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("line_break")),
            .helperArrow(TokenInfo("->")),
            .character(TokenInfo("u000D")),
            .semicolon(TokenInfo(";")),

            .identifier(TokenInfo("line_break")),
            .helperArrow(TokenInfo("->")),
            .character(TokenInfo("u000D")),
            .character(TokenInfo("u000A")),
            .semicolon(TokenInfo(";")),
        ]

        XCTAssertEqual(actualTokens.count, expectedTokens.count)

        for i in 0..<actualTokens.count
        {
            XCTAssertEqual(actualTokens[i], expectedTokens[i])
        }

    }

    static var allTests =
    [
        ("testExample", testExample),
    ]
}
