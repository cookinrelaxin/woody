import XCTest
import Foundation
@testable import woody

class ContextHandlerTests: XCTestCase
{
    @available(macOS 10.11, *)
    func testBuildAST()
    {
        let url = URL(fileURLWithPath: "testBuildAST.woody",
                      relativeTo: fixtureURL)
        let coordinator = PipelineCoordinator(url: url)

        /*print(try! coordinator.parser.parseTree())*/

        let ast = coordinator.astFactory.abstractSyntaxTree

        XCTAssertEqual(ast.rules.count, 4)
        XCTAssert(ast.rules.contains
            { $0.tokenClass == "whitespace" && $0.order == 0 })
        XCTAssert(ast.rules.contains
            { $0.tokenClass == "identifier" && $0.order == 1 })
        XCTAssert(ast.rules.contains
            { $0.tokenClass == "keyword" && $0.order == 2 })
        XCTAssert(ast.rules.contains
            { $0.tokenClass == "punctuation" && $0.order == 3 })

        /*print(ast)*/
    }
}

