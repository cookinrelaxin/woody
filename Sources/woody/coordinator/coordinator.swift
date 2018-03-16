import Foundation

final class PipelineCoordinator
{
    let reader: Reader
    let lexer: Lexer
    let parser: Parser

    init(url: URL)
    {
        reader = try! Reader(source: url)
        lexer = Lexer(reader: reader)!
        parser = Parser(lexer: lexer)
    }
}
