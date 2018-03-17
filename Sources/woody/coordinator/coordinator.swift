import Foundation

final class PipelineCoordinator
{
    let source: URL

    lazy var reader: Reader =
    {
        return try! Reader(source: source)
    }()

    lazy var lexer: Lexer =
    {
        return Lexer(reader: reader)!
    }()

    lazy var parser         : Parser =
    {
        return Parser(lexer: lexer)
    }()

    lazy var lexerGenerator : LexerGenerator =
    {
        return LexerGenerator(regularDescription: try! parser.parseTree())
    }()

    init(url: URL) { source = url }
}
