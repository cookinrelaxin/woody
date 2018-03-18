import Foundation

final class ASTFactory
{
    private let parseTree: Parser.ParseTree

    func abstractSyntaxTree() throws -> AbstractSyntaxTree
    {
        fatalError()
        /*return AbstractSyntaxTree(for: parseTree)*/
    }

    init(parseTree: Parser.ParseTree)
    {
        self.parseTree = parseTree
    }
}
