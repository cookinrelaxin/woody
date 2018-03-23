import XCTest
import Foundation
@testable import woody

class LexerGeneratorTests: XCTestCase
{
/*
 *    @available(macOS 10.11, *)
 *    func testGenTransitionTable()
 *    {
 *        let url = URL(fileURLWithPath: "testBuildAST.woody",
 *                      relativeTo: fixtureURL)
 *        let coordinator = PipelineCoordinator(url: url)
 *        let lexerGenerator = coordinator.lexerGenerator
 *
 *        let transitionTable = lexerGenerator.transitionTable
 *        let strippedTransitionTable = lexerGenerator.strippedTransitionTable
 *
 *        XCTAssertEqual(transitionTable.count, strippedTransitionTable.count)
 *    }
 */

    @available(macOS 10.11, *)
    func testBuildSBERT()
    {
        let url = URL(fileURLWithPath: "testBuildAST.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        let elementaryRanges = lexerGenerator.elementaryRanges
        let sbert = lexerGenerator.sbert

        XCTAssertTrue(sbert.isBalanced)
        XCTAssertTrue(sbert.bstInvariantHolds)
        XCTAssertTrue(sbert.isAVL)
        XCTAssertTrue(sbert.count == elementaryRanges.count)
        XCTAssertTrue(sbert.values == elementaryRanges)

        for e in lexerGenerator.elementaryRanges
        {
            switch e
            {
            case let .scalar(s):
                let r = sbert.range(for: s)
                XCTAssertNotNil(r)
                XCTAssertEqual(e, r!)

            case let .discreteSegment(s,t):
                if let member = Scalar(UInt32((s.value+t.value)/2))
                {
                    let r = sbert.range(for: member)
                    XCTAssertNotNil(r)
                    XCTAssertEqual(e, r!)
                }
            }
        }
    }

}
