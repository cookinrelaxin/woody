import XCTest
import Foundation
@testable import woody

class LexerTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testSwift()
    {
        let url = URL(fileURLWithPath: "swift.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualTokens = coordinator.lexer.tokens
        /*print(actualTokens)*/

        let expectedTokens: [Token] =
        [
            Identifier                 ("whitespace"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("whitespace_item"),
            OneOrMoreOperator          ("+"),
            RuleTerminator             (";"),

            Identifier                 ("identifier"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("identifier_head"),
            Identifier                 ("identifier_character"),
            ZeroOrMoreOperator         ("*"),
            RuleTerminator             (";"),

            Identifier                 ("keyword"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("declaration_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("statement_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("expression_or_type_keyword"),
            RuleTerminator             (";"),

            Identifier                 ("punctuation"),
            TokenDefinitionMarker      ("=>"),
            Character                  ("'("),
            UnionOperator              ("|"),
            Character                  ("')"),
            UnionOperator              ("|"),
            Character                  ("'{"),
            UnionOperator              ("|"),
            Character                  ("'}"),
            UnionOperator              ("|"),
            Character                  ("'["),
            UnionOperator              ("|"),
            Character                  ("']"),
            UnionOperator              ("|"),
            Character                  ("'."),
            UnionOperator              ("|"),
            Character                  ("',"),
            UnionOperator              ("|"),
            Character                  ("':"),
            UnionOperator              ("|"),
            Character                  ("';"),
            RuleTerminator             (";"),

            Identifier                 ("whitespace"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("whitespace_item"),
            OneOrMoreOperator          ("+"),
            RuleTerminator             (";"),

            Identifier                 ("whitespace_item"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("line_break"),
            RuleTerminator             (";"),

            Identifier                 ("whitespace_item"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("comment"),
            RuleTerminator             (";"),

            Identifier                 ("whitespace_item"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("multiline_comment"),
            RuleTerminator             (";"),

            Identifier                 ("whitespace_item"),
            HelperDefinitionMarker     ("->"),
            BracketedSetLeftDelimiter  ("{"),
            Character                  ("u0000"),
            SetSeparator               (","),
            Character                  ("u0009"),
            SetSeparator               (","),
            Character                  ("u000B"),
            SetSeparator               (","),
            Character                  ("u000C"),
            SetSeparator               (","),
            Character                  ("u0020"),
            BracketedSetRightDelimiter ("}"),
            RuleTerminator             (";"),

            Identifier                 ("line_break"),
            HelperDefinitionMarker     ("->"),
            Character                  ("u000A"),
            RuleTerminator             (";"),

            Identifier                 ("line_break"),
            HelperDefinitionMarker     ("->"),
            Character                  ("u000D"),
            RuleTerminator             (";"),

            Identifier                 ("line_break"),
            HelperDefinitionMarker     ("->"),
            Character                  ("u000D"),
            Character                  ("u000A"),
            RuleTerminator             (";"),

            Identifier                 ("comment"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"//\""),
            Identifier                 ("commentText"),
            Identifier                 ("lineBreak"),
            RuleTerminator             (";"),

            Identifier                 ("multiline_comment"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"/*\""),
            Identifier                 ("commentText"),
            String                     ("\"*/\""),
            RuleTerminator             (";"),

            Identifier                 ("commentText"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("commentTextItem"),
            OneOrMoreOperator          ("+"),
            RuleTerminator             (";"),

            Identifier                 ("commentTextItem"),
            HelperDefinitionMarker     ("->"),
            Unicode                    ("U"),
            SetMinus                   ("\\"),
            BracketedSetLeftDelimiter  ("{"),
            Character                  ("u000A"),
            SetSeparator               (","),
            Character                  ("u000D"),
            BracketedSetRightDelimiter ("}"),
            RuleTerminator             (";"),

            Identifier                 ("identifier"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("identifier_head"),
            Identifier                 ("identifier_character"),
            ZeroOrMoreOperator         ("*"),
            RuleTerminator             (";"),

            Identifier                 ("identifier"),
            HelperDefinitionMarker     ("->"),
            Character                  ("'`"),
            Identifier                 ("identifier_head"),
            Identifier                 ("identifier_character"),
            ZeroOrMoreOperator         ("*"),
            Character                  ("'`"),
            RuleTerminator             (";"),

            Identifier                 ("identifier"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("implicit_parameter_name"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_head"),
            HelperDefinitionMarker     ("->"),
            Character                  ("'a"),
            RangeSeparator             ("-"),
            Character                  ("'z"),
            UnionOperator              ("|"),
            Character                  ("'A"),
            RangeSeparator             ("-"),
            Character                  ("'Z"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_head"),
            HelperDefinitionMarker     ("->"),
            Character                  ("'_"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_head"),
            HelperDefinitionMarker     ("->"),
            BracketedSetLeftDelimiter  ("{"),

            Character                  ("u00A8"),
            SetSeparator               (","),
            Character                  ("u00AA"),
            SetSeparator               (","),
            Character                  ("u00AF"),
            SetSeparator               (","),
            Character                  ("u00B2"),
            RangeSeparator             ("-"),
            Character                  ("u00B5"),
            SetSeparator               (","),
            Character                  ("u00B7"),
            RangeSeparator             ("-"),
            Character                  ("u00BA"),
            SetSeparator               (","),
            Character                  ("u00BC"),
            RangeSeparator             ("-"),
            Character                  ("u00BE"),
            SetSeparator               (","),
            Character                  ("u00C0"),
            RangeSeparator             ("-"),
            Character                  ("u00D6"),
            SetSeparator               (","),
            Character                  ("u00D8"),
            RangeSeparator             ("-"),
            Character                  ("u00F6"),
            SetSeparator               (","),
            Character                  ("u00F8"),
            RangeSeparator             ("-"),
            Character                  ("u00FF"),
            SetSeparator               (","),
            Character                  ("u0100"),
            RangeSeparator             ("-"),
            Character                  ("u02FF"),
            SetSeparator               (","),
            Character                  ("u0370"),
            RangeSeparator             ("-"),
            Character                  ("u167F"),
            SetSeparator               (","),
            Character                  ("u1681"),
            RangeSeparator             ("-"),
            Character                  ("u180D"),
            SetSeparator               (","),
            Character                  ("u180F"),
            RangeSeparator             ("-"),
            Character                  ("u1DBF"),
            SetSeparator               (","),
            Character                  ("u1E00"),
            RangeSeparator             ("-"),
            Character                  ("u1FFF"),
            SetSeparator               (","),
            Character                  ("u200B"),
            RangeSeparator             ("-"),
            Character                  ("u200D"),
            SetSeparator               (","),
            Character                  ("u202A"),
            RangeSeparator             ("-"),
            Character                  ("u202E"),
            SetSeparator               (","),
            Character                  ("u203F"),
            RangeSeparator             ("-"),
            Character                  ("u2040"),
            SetSeparator               (","),
            Character                  ("u2054"),
            SetSeparator               (","),
            Character                  ("u2060"),
            RangeSeparator             ("-"),
            Character                  ("u206F"),
            SetSeparator               (","),
            Character                  ("u2070"),
            RangeSeparator             ("-"),
            Character                  ("u20CF"),
            SetSeparator               (","),
            Character                  ("u2100"),
            RangeSeparator             ("-"),
            Character                  ("u218F"),
            SetSeparator               (","),
            Character                  ("u2460"),
            RangeSeparator             ("-"),
            Character                  ("u24FF"),
            SetSeparator               (","),
            Character                  ("u2776"),
            RangeSeparator             ("-"),
            Character                  ("u2793"),
            SetSeparator               (","),
            Character                  ("u2C00"),
            RangeSeparator             ("-"),
            Character                  ("u2DFF"),
            Character                  ("u2E80"),
            RangeSeparator             ("-"),
            Character                  ("u2FFF"),
            SetSeparator               (","),
            Character                  ("u3004"),
            RangeSeparator             ("-"),
            Character                  ("u3007"),
            SetSeparator               (","),
            Character                  ("u3021"),
            RangeSeparator             ("-"),
            Character                  ("u302F"),
            SetSeparator               (","),
            Character                  ("u3031"),
            RangeSeparator             ("-"),
            Character                  ("u303F"),
            SetSeparator               (","),
            Character                  ("u3040"),
            RangeSeparator             ("-"),
            Character                  ("uD7FF"),
            SetSeparator               (","),
            Character                  ("uF900"),
            RangeSeparator             ("-"),
            Character                  ("uFD3D"),
            SetSeparator               (","),
            Character                  ("uFD40"),
            RangeSeparator             ("-"),
            Character                  ("uFDCF"),
            SetSeparator               (","),
            Character                  ("uFDF0"),
            RangeSeparator             ("-"),
            Character                  ("uFE1F"),
            SetSeparator               (","),
            Character                  ("uFE30"),
            RangeSeparator             ("-"),
            Character                  ("uFE44"),
            SetSeparator               (","),
            Character                  ("uFE47"),
            RangeSeparator             ("-"),
            Character                  ("uFFFD"),
            SetSeparator               (","),
            Character                  ("u10000"),
            RangeSeparator             ("-"),
            Character                  ("u1FFFD"),
            SetSeparator               (","),
            Character                  ("u20000"),
            RangeSeparator             ("-"),
            Character                  ("u2FFFD"),
            SetSeparator               (","),
            Character                  ("u30000"),
            RangeSeparator             ("-"),
            Character                  ("u3FFFD"),
            SetSeparator               (","),
            Character                  ("u40000"),
            RangeSeparator             ("-"),
            Character                  ("u4FFFD"),
            SetSeparator               (","),
            Character                  ("u50000"),
            RangeSeparator             ("-"),
            Character                  ("u5FFFD"),
            SetSeparator               (","),
            Character                  ("u60000"),
            RangeSeparator             ("-"),
            Character                  ("u6FFFD"),
            SetSeparator               (","),
            Character                  ("u70000"),
            RangeSeparator             ("-"),
            Character                  ("u7FFFD"),
            SetSeparator               (","),
            Character                  ("u80000"),
            RangeSeparator             ("-"),
            Character                  ("u8FFFD"),
            SetSeparator               (","),
            Character                  ("u90000"),
            RangeSeparator             ("-"),
            Character                  ("u9FFFD"),
            SetSeparator               (","),
            Character                  ("uA0000"),
            RangeSeparator             ("-"),
            Character                  ("uAFFFD"),
            SetSeparator               (","),
            Character                  ("uB0000"),
            RangeSeparator             ("-"),
            Character                  ("uBFFFD"),
            SetSeparator               (","),
            Character                  ("uC0000"),
            RangeSeparator             ("-"),
            Character                  ("uCFFFD"),
            SetSeparator               (","),
            Character                  ("uD0000"),
            RangeSeparator             ("-"),
            Character                  ("uDFFFD"),
            SetSeparator               (","),
            Character                  ("uE0000"),
            RangeSeparator             ("-"),
            Character                  ("uEFFFD"),

            BracketedSetRightDelimiter ("}"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_character"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("decimal_digit"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_character"),
            HelperDefinitionMarker     ("->"),
            Character                  ("u0300"),
            RangeSeparator             ("-"),
            Character                  ("u036F"),
            UnionOperator              ("|"),
            Character                  ("u1DC0"),
            RangeSeparator             ("-"),
            Character                  ("u1DFF"),
            UnionOperator              ("|"),
            Character                  ("u20D0"),
            RangeSeparator             ("-"),
            Character                  ("u20FF"),
            UnionOperator              ("|"),
            Character                  ("uFE20"),
            RangeSeparator             ("-"),
            Character                  ("uFE2F"),
            RuleTerminator             (";"),

            Identifier                 ("identifier_character"),
            HelperDefinitionMarker     ("->"),
            Identifier                 ("identifier_head"),
            RuleTerminator             (";"),

            Identifier                 ("implicit_parameter_name"),
            HelperDefinitionMarker     ("->"),
            Character                  ("'$"),
            Identifier                 ("decimal_digit"),
            OneOrMoreOperator          ("+"),
            RuleTerminator             (";"),

            Identifier                 ("keyword"),
            TokenDefinitionMarker      ("=>"),
            Identifier                 ("declaration_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("statement_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("expression_or_type_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("pattern_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("hash_keyword"),
            UnionOperator              ("|"),
            Identifier                 ("contextual_keyword"),
            RuleTerminator             (";"),

            Identifier                 ("declaration_keyword"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"associatedtype\""),
            UnionOperator              ("|"),
            String                     ("\"class\""),
            UnionOperator              ("|"),
            String                     ("\"deinit\""),
            UnionOperator              ("|"),
            String                     ("\"enum\""),
            UnionOperator              ("|"),
            String                     ("\"extension\""),
            UnionOperator              ("|"),
            String                     ("\"fileprivate\""),
            UnionOperator              ("|"),
            String                     ("\"func\""),
            UnionOperator              ("|"),
            String                     ("\"import\""),
            UnionOperator              ("|"),
            String                     ("\"init\""),
            UnionOperator              ("|"),
            String                     ("\"inout\""),
            UnionOperator              ("|"),
            String                     ("\"internal\""),
            UnionOperator              ("|"),
            String                     ("\"let\""),
            UnionOperator              ("|"),
            String                     ("\"open\""),
            UnionOperator              ("|"),
            String                     ("\"operator\""),
            UnionOperator              ("|"),
            String                     ("\"private\""),
            UnionOperator              ("|"),
            String                     ("\"protocol\""),
            UnionOperator              ("|"),
            String                     ("\"public\""),
            UnionOperator              ("|"),
            String                     ("\"static\""),
            UnionOperator              ("|"),
            String                     ("\"struct\""),
            UnionOperator              ("|"),
            String                     ("\"subscript\""),
            UnionOperator              ("|"),
            String                     ("\"typealias\""),
            UnionOperator              ("|"),
            String                     ("\"var\""),
            RuleTerminator             (";"),

            Identifier                 ("statement_keyword"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"break\""),
            UnionOperator              ("|"),
            String                     ("\"case\""),
            UnionOperator              ("|"),
            String                     ("\"continue\""),
            UnionOperator              ("|"),
            String                     ("\"default\""),
            UnionOperator              ("|"),
            String                     ("\"defer\""),
            UnionOperator              ("|"),
            String                     ("\"do\""),
            UnionOperator              ("|"),
            String                     ("\"else\""),
            UnionOperator              ("|"),
            String                     ("\"fallthrough\""),
            UnionOperator              ("|"),
            String                     ("\"for\""),
            UnionOperator              ("|"),
            String                     ("\"guard\""),
            UnionOperator              ("|"),
            String                     ("\"if\""),
            UnionOperator              ("|"),
            String                     ("\"in\""),
            UnionOperator              ("|"),
            String                     ("\"repeat\""),
            UnionOperator              ("|"),
            String                     ("\"return\""),
            UnionOperator              ("|"),
            String                     ("\"switch\""),
            UnionOperator              ("|"),
            String                     ("\"where\""),
            UnionOperator              ("|"),
            String                     ("\"while\""),
            RuleTerminator             (";"),

            Identifier                 ("expression_or_type_keyword"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"as\""),
            UnionOperator              ("|"),
            String                     ("\"Any\""),
            UnionOperator              ("|"),
            String                     ("\"catch\""),
            UnionOperator              ("|"),
            String                     ("\"false\""),
            UnionOperator              ("|"),
            String                     ("\"is\""),
            UnionOperator              ("|"),
            String                     ("\"nil\""),
            UnionOperator              ("|"),
            String                     ("\"rethrows\""),
            UnionOperator              ("|"),
            String                     ("\"super\""),
            UnionOperator              ("|"),
            String                     ("\"self\""),
            UnionOperator              ("|"),
            String                     ("\"Self\""),
            UnionOperator              ("|"),
            String                     ("\"throw\""),
            UnionOperator              ("|"),
            String                     ("\"throws\""),
            UnionOperator              ("|"),
            String                     ("\"true\""),
            UnionOperator              ("|"),
            String                     ("\"try\""),
            RuleTerminator             (";"),

            Identifier                 ("pattern_keyword"),
            HelperDefinitionMarker     ("->"),
            Character                  ("'_"),
            RuleTerminator             (";"),

            Identifier                 ("hash_keyword"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"#available\""),
            UnionOperator              ("|"),
            String                     ("\"#colorLiteral\""),
            UnionOperator              ("|"),
            String                     ("\"#column\""),
            UnionOperator              ("|"),
            String                     ("\"#else\""),
            UnionOperator              ("|"),
            String                     ("\"#elseif\""),
            UnionOperator              ("|"),
            String                     ("\"#endif\""),
            UnionOperator              ("|"),
            String                     ("\"#file\""),
            UnionOperator              ("|"),
            String                     ("\"#fileLiteral\""),
            UnionOperator              ("|"),
            String                     ("\"#function\""),
            UnionOperator              ("|"),
            String                     ("\"#if\""),
            UnionOperator              ("|"),
            String                     ("\"#imageLiteral\""),
            UnionOperator              ("|"),
            String                     ("\"#line\""),
            UnionOperator              ("|"),
            String                     ("\"#selector\""),
            UnionOperator              ("|"),
            String                     ("\"#sourceLocation\""),
            RuleTerminator             (";"),

            Identifier                 ("contextual_keyword"),
            HelperDefinitionMarker     ("->"),
            String                     ("\"associativity\""),
            UnionOperator              ("|"),
            String                     ("\"convenience\""),
            UnionOperator              ("|"),
            String                     ("\"dynamic\""),
            UnionOperator              ("|"),
            String                     ("\"didSet\""),
            UnionOperator              ("|"),
            String                     ("\"final\""),
            UnionOperator              ("|"),
            String                     ("\"get\""),
            UnionOperator              ("|"),
            String                     ("\"infix\""),
            UnionOperator              ("|"),
            String                     ("\"indirect\""),
            UnionOperator              ("|"),
            String                     ("\"lazy\""),
            UnionOperator              ("|"),
            String                     ("\"left\""),
            UnionOperator              ("|"),
            String                     ("\"mutating\""),
            UnionOperator              ("|"),
            String                     ("\"none\""),
            UnionOperator              ("|"),
            String                     ("\"nonmutating\""),
            UnionOperator              ("|"),
            String                     ("\"optional\""),
            UnionOperator              ("|"),
            String                     ("\"override\""),
            UnionOperator              ("|"),
            String                     ("\"postfix\""),
            UnionOperator              ("|"),
            String                     ("\"precedence\""),
            UnionOperator              ("|"),
            String                     ("\"prefix\""),
            UnionOperator              ("|"),
            String                     ("\"Protocol\""),
            UnionOperator              ("|"),
            String                     ("\"required\""),
            UnionOperator              ("|"),
            String                     ("\"right\""),
            UnionOperator              ("|"),
            String                     ("\"set\""),
            UnionOperator              ("|"),
            String                     ("\"Type\""),
            UnionOperator              ("|"),
            String                     ("\"unowned\""),
            UnionOperator              ("|"),
            String                     ("\"weak\""),
            UnionOperator              ("|"),
            String                     ("\"willSet\""),
            RuleTerminator             (";"),
        ]

        XCTAssertEqual(actualTokens.count, expectedTokens.count)

        for i in 0..<actualTokens.count
        {
            XCTAssertEqual(actualTokens[i].asEquatable,
                           expectedTokens[i].asEquatable)
        }
    }
}

