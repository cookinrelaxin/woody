import Foundation

final class PipelineCoordinator
{
    let woodySource: Source

    lazy var woodyLexer          : WoodyLexer  =
    { WoodyLexer(woodySource) }()

    lazy var woodyParser         : WoodyParser =
    { WoodyParser(lexer) }()

    lazy var woodyContextHandler : WoodyContextHandler =
    { WoodyContextHandler(parser) }()

    lazy var codeGenerator : CodeGenerator =
    { CodeGenerator(woodyContextHandler) }()

    init(_ woodySourceUrl: URL) { woodySource = Source(woodySourceUrl) }
}
