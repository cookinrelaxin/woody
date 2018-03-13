import XCTest
@testable import woody

class woodyTests: XCTestCase
{
    func testExample()
    {
        let url = URL(fileURLWithPath: "./Tests/woodyTests/example.woody")
        let coordinator = PipelineCoordinator(url: url)

        let tokens = coordinator.lexer.tokens
        print(tokens)
    }

    static var allTests =
    [
        ("testExample", testExample),
    ]
}
