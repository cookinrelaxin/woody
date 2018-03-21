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

        XCTAssertEqual(ast.rules.count, 34)

        print(ast)
    }
}

