import Foundation

enum ContextHandlingError: Error
{
    case undefinedIdentifier(Lexer.Identifier)

    static func print(_ e: ContextHandlingError, _ context: Context)
    {
        switch e
        {
        case let .undefinedIdentifier(lIdentifier):
            let sourceLines = context.sourceLines
            let lineNo = lIdentifier.info.startIndex.line+1
            let sourceURL = lIdentifier.info.source.url.lastPathComponent
            let representation = lIdentifier.representation

            let comment = """
            I unexpectedly found an undefined identifier `\(representation)`.
            """

            let header = "-- Context Handling Error in \(sourceURL) "
            .padding(toLength: 80, withPad: "-", startingAt: 0)

            let lineNoPrefix = "\(lineNo)|"
            let ctxt = """
            \(lineNoPrefix)\(lIdentifier.line)
            """

            let underline = lIdentifier.underline(in: sourceLines,
                                                  offset: lineNoPrefix.count)

            let suggestion = """
            It should be defined in a rule like

            \(representation) -> R;,

            where `R` is a regular expression.
            """

            let msg = """
            \(header)

            \(comment)

            \(ctxt)\(underline)
            \(suggestion)

            """

            Swift.print(msg)
        }
    }
}
