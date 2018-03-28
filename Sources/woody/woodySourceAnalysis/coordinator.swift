import Foundation

final class PipelineCoordinator
{
    let source: URL

    lazy var reader : Reader = { return Reader(source: source) }()
    lazy var lexer  : Lexer  = { return Lexer(reader: reader) }()
    lazy var parser : Parser = { return Parser(lexer: lexer) }()

    lazy var astFactory: ASTFactory = { return ASTFactory(parser: parser) }()

    lazy var lexerGenerator: LexerGenerator =
    { return LexerGenerator(astFactory: astFactory) }()

    init(url: URL) { source = url }
}
