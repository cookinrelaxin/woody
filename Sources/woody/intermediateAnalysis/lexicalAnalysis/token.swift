import Foundation

struct WoodyToken
{
    let source         : Source
    let range          : Source.ClosedRange
    let tokenClass     : String

    lazy var representation: String = { source.string(in: range) }()
    lazy var line: String           = { source.lines(for: range) }()

    init(_ source     : Source,
         _ range      : Source.Range,
         _ tokenClass : String)
    {
        self.source     = source
        self.range      = range
        self.tokenClass = tokenClass
    }
}
