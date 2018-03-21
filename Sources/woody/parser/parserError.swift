import Foundation

struct TokenClassStack
{
    private var data: [TokenClass]

    init() { data = [] }

    mutating func push(_ tokenClass: TokenClass)
    {
        if data.count == 2
        {
            data[0] = data[1]
            data[1] = tokenClass
        }
        else
        {
            data.append(tokenClass)
        }
    }

    mutating func clear()
    {
        data = []
    }

    var enumeration: String
    {
        if data.count == 1
        || (data.count == 2 && data[0] == data[1]) { return "\(data[0])" }
        else if data.count == 2
        {
            return "\(data[0]), or \(data[1])"
        }
        preconditionFailure()
    }
}

enum ParserError: Error
{
    case expected(TokenClass)

    static func printExpectationErrorMessage(_ expected: TokenClassStack,
                                             _ actual: Token,
                                             _ sourceLines: SourceLines)
    {
        let lineNo = actual.info.startIndex.line+1
        let line = actual.line(in: sourceLines)
        let sourceURL = actual.info.sourceURL.lastPathComponent

        let comment = """
        I unexpectedly found \(actual.tokenClass.english)\
         `\(actual.representation(in: sourceLines))` here.
        """

        let header = "-- Parsing Error in \(sourceURL) ".padding(toLength: 80,
                                                                withPad: "-",
                                                                startingAt: 0)

        let lineNoPrefix = "\(lineNo)| "
        let ctxt = """
        \(lineNoPrefix)\(line)
        """

        let _underline = underline(for: actual,
                                   in: sourceLines,
                                   offset: lineNoPrefix.count)

        let suggestion = """
        But there should be \(expected.enumeration).
        """

        let msg = """
        \(header)

        \(comment)

        \(ctxt)\(_underline)
        \(suggestion)

        """

        print(msg)
    }

    case unexpectedEndOfInput
}

private func underline(for token: Token,
                       in sourceLines: SourceLines,
                       offset: Int) -> String
{
    let start = token.info.startIndex
    let end = token.info.endIndex
    let scalars = sourceLines[start.line]

    var underline = [Scalar]()

    for i in 0..<scalars.count
    {
        if start.char <= i && i <= end.char
        { underline.append("^") }
        else
        { underline.append(" ") }
    }

    underline = [Scalar](repeating: " ", count: offset) + underline

    return String(String.UnicodeScalarView(underline))
}
