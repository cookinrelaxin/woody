import Foundation

enum ContextHandlingError: Error
{
    case undefinedIdentifier(Lexer.Identifier)
    case recursiveTokenDefinition(Lexer.Identifier)

    static func print(_ e: ContextHandlingError, _ context: Context)
    {
        switch e
        {
        case let .undefinedIdentifier(lIdentifier):
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

            let underline = lIdentifier.underline(offset: lineNoPrefix.count)

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

        case let .recursiveTokenDefinition(lIdentifier):
            let lineNo = lIdentifier.info.startIndex.line+1
            let sourceURL = lIdentifier.info.source.url.lastPathComponent

            let comment = """
            I unexpectedly found a recursive token definition.
            """

            let header = "-- Context Handling Error in \(sourceURL) "
            .padding(toLength: 80, withPad: "-", startingAt: 0)

            let lineNoPrefix = "\(lineNo)|"
            let ctxt = """
            \(lineNoPrefix)\(lIdentifier.line)
            """

            let underline = lIdentifier.underline(offset: lineNoPrefix.count)

            let suggestion = """
            Sorry, but support for recursive token definitions is currently\
             unimplemented. You might be able to capture the same semantics by\
             using the zero-or-more operator `*` or the one-or-more operator\
              `+`.
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
