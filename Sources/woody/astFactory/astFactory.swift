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

    init(parseTree: ParseTree, sourceLines: SourceLines)
    {
        self.parseTree = parseTree
        self.sourceLines = sourceLines
    }
}
