import XCTest
import Foundation
@testable import woody

class LexerGeneratorTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testGenTransitionTableSmall()
    {
        let url = URL(fileURLWithPath: "testGenTransitionTable.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        let transitionTable = lexerGenerator.transitionTable
        let strippedTransitionTable =
        lexerGenerator.strippedTransitionTable.table

        XCTAssertEqual(transitionTable.count, strippedTransitionTable.count)

        let values = strippedTransitionTable.values

        XCTAssert(values.contains { $0.tokenClass == "identifier" })
        XCTAssert(values.contains { $0.tokenClass == "integer" })
        XCTAssert(values.contains { $0.tokenClass == "single_character" })
    }

    @available(macOS 10.11, *)
    func testGenTransitionTableMedium()
    {
        let url = URL(fileURLWithPath: "testGenTransitionTableMedium.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        let transitionTable = lexerGenerator.transitionTable
        let strippedTransitionTable =
        lexerGenerator.strippedTransitionTable.table

        XCTAssertEqual(transitionTable.count, strippedTransitionTable.count)

        let values = strippedTransitionTable.values

        XCTAssert(values.contains { $0.tokenClass == "associatedtype_kw" })
        XCTAssert(values.contains { $0.tokenClass == "class_kw" })
        XCTAssert(values.contains { $0.tokenClass == "deinit_kw" })
        XCTAssert(values.contains { $0.tokenClass == "enum_kw" })
        XCTAssert(values.contains { $0.tokenClass == "extension_kw" })
        XCTAssert(values.contains { $0.tokenClass == "fileprivate_kw" })
        XCTAssert(values.contains { $0.tokenClass == "func_kw" })
        XCTAssert(values.contains { $0.tokenClass == "import_kw" })
        XCTAssert(values.contains { $0.tokenClass == "init_kw" })
        XCTAssert(values.contains { $0.tokenClass == "inout_kw" })
        XCTAssert(values.contains { $0.tokenClass == "internal_kw" })
        XCTAssert(values.contains { $0.tokenClass == "let_kw" })
        XCTAssert(values.contains { $0.tokenClass == "open_kw" })
        XCTAssert(values.contains { $0.tokenClass == "operator_kw" })
        XCTAssert(values.contains { $0.tokenClass == "private_kw" })
        XCTAssert(values.contains { $0.tokenClass == "protocol_kw" })
        XCTAssert(values.contains { $0.tokenClass == "public_kw" })
        XCTAssert(values.contains { $0.tokenClass == "static_kw" })
        XCTAssert(values.contains { $0.tokenClass == "struct_kw" })
        XCTAssert(values.contains { $0.tokenClass == "subscript_kw" })
        XCTAssert(values.contains { $0.tokenClass == "typealias_kw" })
        XCTAssert(values.contains { $0.tokenClass == "var_kw" })
        XCTAssert(values.contains { $0.tokenClass == "break_kw" })
        XCTAssert(values.contains { $0.tokenClass == "case_kw" })
        XCTAssert(values.contains { $0.tokenClass == "continue_kw" })
        XCTAssert(values.contains { $0.tokenClass == "default_kw" })
        XCTAssert(values.contains { $0.tokenClass == "defer_kw" })
        XCTAssert(values.contains { $0.tokenClass == "do_kw" })
        XCTAssert(values.contains { $0.tokenClass == "else_kw" })
        XCTAssert(values.contains { $0.tokenClass == "fallthrough_kw" })
        XCTAssert(values.contains { $0.tokenClass == "for_kw" })
        XCTAssert(values.contains { $0.tokenClass == "guard_kw" })
        XCTAssert(values.contains { $0.tokenClass == "if_kw" })
        XCTAssert(values.contains { $0.tokenClass == "in_kw" })
        XCTAssert(values.contains { $0.tokenClass == "repeat_kw" })
        XCTAssert(values.contains { $0.tokenClass == "return_kw" })
        XCTAssert(values.contains { $0.tokenClass == "switch_kw" })
        XCTAssert(values.contains { $0.tokenClass == "where_kw" })
        XCTAssert(values.contains { $0.tokenClass == "while_kw" })
        XCTAssert(values.contains { $0.tokenClass == "as_kw" })
        XCTAssert(values.contains { $0.tokenClass == "any_kw" })
        XCTAssert(values.contains { $0.tokenClass == "catch_kw" })
        XCTAssert(values.contains { $0.tokenClass == "false_kw" })
        XCTAssert(values.contains { $0.tokenClass == "is_kw" })
        XCTAssert(values.contains { $0.tokenClass == "nil_kw" })
        XCTAssert(values.contains { $0.tokenClass == "rethrows_kw" })
        XCTAssert(values.contains { $0.tokenClass == "super_kw" })
        XCTAssert(values.contains { $0.tokenClass == "lc_self_kw" })
        XCTAssert(values.contains { $0.tokenClass == "uc_self_kw" })
        XCTAssert(values.contains { $0.tokenClass == "throw_kw" })
        XCTAssert(values.contains { $0.tokenClass == "throws_kw" })
        XCTAssert(values.contains { $0.tokenClass == "true_kw" })
        XCTAssert(values.contains { $0.tokenClass == "try_kw" })
        XCTAssert(values.contains { $0.tokenClass == "underscore_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_available_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_colorLiteral_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_column_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_else_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_elseif_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_endif_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_file_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_fileLiteral_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_function_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_if_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_imageLiteral_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_line_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_selector_kw" })
        XCTAssert(values.contains { $0.tokenClass == "hash_sourceLocation_kw" })
        XCTAssert(values.contains { $0.tokenClass == "associativity_kw" })
        XCTAssert(values.contains { $0.tokenClass == "convenience_kw" })
        XCTAssert(values.contains { $0.tokenClass == "dynamic_kw" })
        XCTAssert(values.contains { $0.tokenClass == "didSet_kw" })
        XCTAssert(values.contains { $0.tokenClass == "final_kw" })
        XCTAssert(values.contains { $0.tokenClass == "get_kw" })
        XCTAssert(values.contains { $0.tokenClass == "infix_kw" })
        XCTAssert(values.contains { $0.tokenClass == "indirect_kw" })
        XCTAssert(values.contains { $0.tokenClass == "lazy_kw" })
        XCTAssert(values.contains { $0.tokenClass == "left_kw" })
        XCTAssert(values.contains { $0.tokenClass == "mutating_kw" })
        XCTAssert(values.contains { $0.tokenClass == "none_kw" })
        XCTAssert(values.contains { $0.tokenClass == "nonmutating_kw" })
        XCTAssert(values.contains { $0.tokenClass == "optional_kw" })
        XCTAssert(values.contains { $0.tokenClass == "override_kw" })
        XCTAssert(values.contains { $0.tokenClass == "postfix_kw" })
        XCTAssert(values.contains { $0.tokenClass == "precedence_kw" })
        XCTAssert(values.contains { $0.tokenClass == "prefix_kw" })
        XCTAssert(values.contains { $0.tokenClass == "protocol_kw" })
        XCTAssert(values.contains { $0.tokenClass == "required_kw" })
        XCTAssert(values.contains { $0.tokenClass == "right_kw" })
        XCTAssert(values.contains { $0.tokenClass == "set_kw" })
        XCTAssert(values.contains { $0.tokenClass == "type_kw" })
        XCTAssert(values.contains { $0.tokenClass == "unowned_kw" })
        XCTAssert(values.contains { $0.tokenClass == "weak_kw" })
        XCTAssert(values.contains { $0.tokenClass == "willSet_kw" })

        XCTAssert(values.contains { $0.tokenClass == "left_parenthesis_punc" })
        XCTAssert(values.contains { $0.tokenClass == "right_parenthesis_punc" })
        XCTAssert(values.contains { $0.tokenClass == "left_brace_punc" })
        XCTAssert(values.contains { $0.tokenClass == "right_brace_punc" })
        XCTAssert(values.contains { $0.tokenClass == "left_bracket_punc" })
        XCTAssert(values.contains { $0.tokenClass == "right_bracket_punc" })
        XCTAssert(values.contains { $0.tokenClass == "period_punc" })
        XCTAssert(values.contains { $0.tokenClass == "comma_punc" })
        XCTAssert(values.contains { $0.tokenClass == "colon_punc" })
        XCTAssert(values.contains { $0.tokenClass == "semicolon_punc" })
        XCTAssert(values.contains { $0.tokenClass == "equals_punc" })
        XCTAssert(values.contains { $0.tokenClass == "at_punc" })
        XCTAssert(values.contains { $0.tokenClass == "hash_punc" })
        XCTAssert(values.contains { $0.tokenClass == "ampersand_punc" })
        XCTAssert(values.contains { $0.tokenClass == "arrow_punc" })
        XCTAssert(values.contains { $0.tokenClass == "backtick_punc" })
        XCTAssert(values.contains { $0.tokenClass == "question_punc" })
        XCTAssert(values.contains { $0.tokenClass == "exclamation_punc" })

        XCTAssert(values.contains { $0.tokenClass == "whitespace" })
        XCTAssert(values.contains { $0.tokenClass == "identifier" })
    }

    @available(macOS 10.11, *)
    func testRelativeSubstateLookup()
    {
        let url = URL(fileURLWithPath: "testGenTransitionTableMedium.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        measure { _ = lexerGenerator.relevantSubstateLookup(for:
            lexerGenerator.initialState) }

        let lookup = lexerGenerator.relevantSubstateLookup(for:
            lexerGenerator.initialState)

        let e = ElementaryRange.scalar(" ")

        let relevantSubstate = lookup[e]

        XCTAssertNotNil(relevantSubstate)

        let p = LexerGenerator.TransitionPair(relevantSubstate!, e)
        let endState = lexerGenerator._endState(for: p)

        XCTAssert(endState.contains { $0.regex == AST.Regex() })
    }

    @available(macOS 10.11, *)
    func testBuildSBERT()
    {
        let url = URL(fileURLWithPath: "testGenTransitionTableMedium.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        let elementaryRanges = lexerGenerator.elementaryRanges
        let sbert = lexerGenerator.sbert

        XCTAssertTrue(sbert.isBalanced)
        XCTAssertTrue(sbert.bstInvariantHolds)
        XCTAssertTrue(sbert.isAVL)
        XCTAssertEqual(sbert.count, elementaryRanges.count)
        XCTAssertEqual(sbert.values, elementaryRanges)
        do
        {
            let l = Scalar(UInt32(0))!
            let u = Scalar(UInt32(0x100000))!
            let r = ScalarRange(l...u)
            let ranges = sbert[r]

            XCTAssertEqual(ranges.count, elementaryRanges.count)

            for (r1, r2) in zip(ranges.sorted(), elementaryRanges.sorted())
            { XCTAssertEqual(r1, r2) }
        }

        for e in elementaryRanges
        {
            switch e
            {
            case let .scalar(s):
                let r = sbert[s]
                XCTAssertNotNil(r)
                XCTAssertEqual(e, r!)

            case let .discreteSegment(s,t):
                if let member = Scalar(UInt32((s.value+t.value)/2))
                {
                    let r = sbert[member]
                    XCTAssertNotNil(r)
                    XCTAssertEqual(e, r!)
                }
            }
        }
    }

    @available(macOS 10.11, *)
    func testAnalysis()
    {
        let url = URL(fileURLWithPath: "testGenTransitionTableMedium.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        let source = """
        @available(macOS 10.11, *)
        func testGenTransitionTableSmall()
        {
            let url = URL(fileURLWithPath: "testGenTransitionTable.woody",
                          relativeTo: fixtureURL)
            let coordinator = PipelineCoordinator(url: url)
            let lexerGenerator = coordinator.lexerGenerator

            let transitionTable = lexerGenerator.transitionTable
            let strippedTransitionTable =
            lexerGenerator.strippedTransitionTable.table

            XCTAssertEqual(transitionTable.count, strippedTransitionTable.count)

            let values = strippedTransitionTable.values

            XCTAssert(values.contains { $0.tokenClass == "identifier" })
            XCTAssert(values.contains { $0.tokenClass == "integer" })
            XCTAssert(values.contains { $0.tokenClass == "single_character" })
        }
        """

        for token in lexerGenerator.analyze(source.unicodeScalars)
        { print("token: (\(token.0) \(token.1 ?? "nil"))") }
    }

}
