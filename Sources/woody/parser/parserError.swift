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
        let sourceURL = actual.info.source.url.lastPathComponent

        let comment = """
        I unexpectedly found \(actual.tokenClass.english)\
         `\(actual.representation)` here.
        """

        let header = "-- Parsing Error in \(sourceURL) ".padding(toLength: 80,
                                                                withPad: "-",
                                                                startingAt: 0)

        let lineNoPrefix = "\(lineNo)|"
        let ctxt = """
        \(lineNoPrefix)\(actual.line)
        """

        let underline = actual.underline(offset: lineNoPrefix.count)

        let suggestion = """
        But there should be \(expected.enumeration).
        """

        let msg = """
        \(header)

        \(comment)

        \(ctxt)\(underline)
        \(suggestion)

        """

        print(msg)
    }

    case unexpectedEndOfInput
    static func printUnexpectedEndOfInputMessage(_ lastToken: Token)
    {
        let lineNo = lastToken.info.startIndex.line+1
        let sourceURL = lastToken.info.source.url.lastPathComponent

        let comment = """
        I unexpectedly found the end of input here.
        """

        let header = "-- Parsing Error in \(sourceURL) ".padding(toLength: 80,
                                                                withPad: "-",
                                                                startingAt: 0)

        let lineNoPrefix = "\(lineNo)|"
        let ctxt = """
        \(lineNoPrefix)\(lastToken.line)
        """

        let underline = lastToken.underlineAfter(offset: lineNoPrefix.count)

        let suggestion = """
        Did you forget a semicolon?
        """

        let msg = """
        \(header)

        \(comment)

        \(ctxt)\(underline)
        \(suggestion)

        """

        print(msg)
    }
}

extension Token
{
    func underline(offset: Int) -> String
    {
        let start = info.startIndex
        let end = info.endIndex
        let scalars = info.source[start.line]

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

    func underlineAfter(offset: Int) -> String
    {
        let line = info.source[info.startIndex.line]
        var underline = [Scalar](repeating: " ", count: offset+line.count-1)
        underline.append(Scalar("^")!)

        return String(String.UnicodeScalarView(underline))
    }
}
