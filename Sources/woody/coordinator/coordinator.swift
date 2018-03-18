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

    /*
     *lazy var astFactory : ASTFactory =
     *{
     *    return ASTFactory(regularDescription: try! parser.parseTree())
     *}()
     */

    // lazy var lexerGenerator : LexerGenerator =
    // {
    // }()

    init(url: URL) { source = url }
}
