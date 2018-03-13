import Foundation

final class PipelineCoordinator
{
    let reader: Reader
    let lexer: Lexer

    init(url: URL)
    {
        reader = try! Reader(source: url)
        lexer = Lexer(reader: reader)!
    }
}
