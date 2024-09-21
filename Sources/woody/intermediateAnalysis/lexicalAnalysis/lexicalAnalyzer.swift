import Foundation

struct LexicalAnalyzer
{
    let woodyAST: WoodyAST

    init(_ woodyAST: WoodyAST) { self.woodyAST = woodyAST }

    func analyze(_ source: Source) -> [ Token ]
    {
        fatalError()
    }
}
