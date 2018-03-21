import Foundation

enum ParserError: Error
{
    case expectedIdentifier                 (Token)
    case expectedHelperDefinitionMarker     (Token)
    case expectedTokenDefinitionMarker      (Token)
    case expectedRuleTerminator             (Token)
    case expectedGroupLeftDelimiter         (Token)
    case expectedGroupRightDelimiter        (Token)
    case expectedUnionOperator              (Token)
    case expectedZeroOrMoreOperator         (Token)
    case expectedOneOrMoreOperator          (Token)
    case expectedZeroOrOneOperator          (Token)
    case expectedString                     (Token)
    case expectedSetMinus                   (Token)
    case expectedUnicode                    (Token)
    case expectedCharacter                  (Token)
    case expectedRangeSeparator             (Token)
    case expectedBracketedSetLeftDelimiter  (Token)
    case expectedBracketedSetRightDelimiter (Token)
    case expectedSetSeparator               (Token)

    static func printExpectationErrorMessage(_ expectedTokenClass: String,
                                             _ actualToken: Token,
                                             _ sourceLines: SourceLines)
    {
        let lineNo = actualToken.info.startIndex.line+1
        let line = actualToken.line(in: sourceLines)
        let sourceURL = actualToken.info.sourceURL.lastPathComponent

        let comment = """
        I expected to find a \(expectedTokenClass) token, but I found\
         "\(actualToken.representation(in: sourceLines))" instead.
        """

        let header = "-- Parsing Error in \(sourceURL) ".padding(toLength: 80,
                                                                withPad: "-",
                                                                startingAt: 0)

        let ctxt = """
        \(lineNo)| \(line)
        """

        let msg = """
        \(header)

        \(comment)

        \(ctxt)
        """

        print(msg)
    }

    case unexpectedEndOfInput
}
