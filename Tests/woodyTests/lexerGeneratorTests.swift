import XCTest
import Foundation
@testable import woody

class LexerGeneratorTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testGenTokenDefinitions() throws
    {
        let url = URL(fileURLWithPath: "testGenTokenDefinitions.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        let actualTokenClassDefinitions =
        coordinator.lexerGenerator.tokenClassDefinitions

        let expectedTokenClassDefinitions: Swift.String = """
            struct Whitespace: Token, Equatable {
                let representation: String

                init(_ representation: String)
                { self.representation = representation }
            }

            struct Identifier: Token, Equatable {
                let representation: String

                init(_ representation: String)
                { self.representation = representation }
            }

            struct Keyword: Token, Equatable {
                let representation: String

                init(_ representation: String)
                { self.representation = representation }
            }

            struct Punctuation: Token, Equatable {
                let representation: String

                init(_ representation: String)
                { self.representation = representation }
            }

            """


        XCTAssertEqual(actualTokenClassDefinitions,
                       expectedTokenClassDefinitions)
    }
}
