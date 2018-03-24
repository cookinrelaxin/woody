import Foundation

final class ASTFactory
{
    private let parseTree: ParseTree
    private let sourceLines: SourceLines

    lazy var abstractSyntaxTree: AbstractSyntaxTree =
    {
        return AbstractSyntaxTree(parseTree: parseTree,
                                  sourceLines: sourceLines)
    }()

    init(parser: Parser)
    {
        self.parseTree = parser.parseTree
        self.sourceLines = parser.source
    }
}
