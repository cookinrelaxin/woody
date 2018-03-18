import XCTest
import Foundation
@testable import woody

class LexerGeneratorTests: XCTestCase
{
    // @available(macOS 10.11, *)
    // func testGenTokenDefinitions() throws
    // {
    //     let url = URL(fileURLWithPath: "testGenTokenDefinitions.woody",
    //                   relativeTo: fixtureURL)
    //     let coordinator = PipelineCoordinator(url: url)

    //     let actualTokenClassDefinitions =
    //     coordinator.lexerGenerator.tokenClassDefinitions

    //     let expectedTokenClassDefinitions: Swift.String = """
    //         struct Whitespace: Token, Equatable {
    //             let representation: String

    //             init(_ representation: String)
    //             { self.representation = representation }
    //         }

    //         struct Identifier: Token, Equatable {
    //             let representation: String

    //             init(_ representation: String)
    //             { self.representation = representation }
    //         }

    //         struct Keyword: Token, Equatable {
    //             let representation: String

    //             init(_ representation: String)
    //             { self.representation = representation }
    //         }

    //         struct Punctuation: Token, Equatable {
    //             let representation: String

    //             init(_ representation: String)
    //             { self.representation = representation }
    //         }

    //         """

    //     XCTAssertEqual(actualTokenClassDefinitions,
    //                    expectedTokenClassDefinitions)
    // }

    // func testTokenDefinitionsFromParseTree()
    // {
    //     let url = URL(fileURLWithPath: "testTokenDefinitionsFromParseTree.woody",
    //                   relativeTo: fixtureURL)
    //     let coordinator = PipelineCoordinator(url: url)

    //     let lexerGenerator = coordinator.lexerGenerator
    //     let actualRegex = lexerGenerator.tokenDefinitions(for:
    //         lexerGenerator.regularDescription)

    //     let expectedTokenClassDefinitions: [TokenDefinition] =
    //     [
    //         TokenDefinition(name: "whitespace",
    //             regex: Regex.
    //     ]

    //     XCTAssertEqual(actualTokenDefinitions, expectedTokenDefinitions)

    // }

/*
 *    func testRelevantCharacterClasses()
 *    {
 *        let url = URL(fileURLWithPath: "testRelevantCharacterClasses.woody",
 *                      relativeTo: fixtureURL)
 *        let coordinator = PipelineCoordinator(url: url)
 *
 *        let actualCharacterClasses =
 *        coordinator.lexerGenerator.relevantCharacterClasses(for: regex)
 *
 *        let expectedCharacterClasses: Swift.Set<CharacterClass> =
 *        [
 *
 *        ]
 *
 *
 *        XCTAssertEqual(actualCharacterClasses, expectedCharacterClasses)
 *    }
 */
}
