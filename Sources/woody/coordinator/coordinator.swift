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
        return Lexer(reader: reader)
    }()

    lazy var parser: Parser =
    {
        return Parser(lexer: lexer)
    }()

    lazy var astFactory: ASTFactory =
    {
        return ASTFactory(parseTree: try! parser.parseTree()!,
                          sourceLines: reader.data)
    }()

    lazy var lexerGenerator: LexerGenerator =
    {
        return LexerGenerator(ast: astFactory.abstractSyntaxTree)
    }()

    init(url: URL) { source = url }
}
