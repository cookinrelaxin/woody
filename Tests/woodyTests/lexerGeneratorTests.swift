import XCTest
import Foundation
@testable import woody

class LexerGeneratorTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testGenTransitionTable()
    {
        let url = URL(fileURLWithPath: "testBuildAST.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)
        let lexerGenerator = coordinator.lexerGenerator

        /*print(lexerGenerator.initialState)*/
        /*print(lexerGenerator.mentionedCharacterSets)*/

        let transitionTable = lexerGenerator.transitionTable
        let strippedTransitionTable = lexerGenerator.strippedTransitionTable

        XCTAssertEqual(transitionTable.count, strippedTransitionTable.count)

        /*print(strippedTransitionTable)*/
        print(lexerGenerator.mentionedCharacterSets)
    }
}
