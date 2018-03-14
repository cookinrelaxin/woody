enum Token: Equatable
{
    case identifier                 (TokenInfo)
    case helperDefinitionMarker     (TokenInfo)
    case tokenDefinitionMarker      (TokenInfo)
    case ruleTerminator             (TokenInfo)
    case groupLeftDelimiter         (TokenInfo)
    case groupRightDelimiter        (TokenInfo)
    case unionOperator              (TokenInfo)
    case zeroOrMoreOperator         (TokenInfo)
    case oneOrMoreOperator          (TokenInfo)
    case zeroOrOneOperator          (TokenInfo)
    case lineHeadOperator           (TokenInfo)
    case lineTailOperator           (TokenInfo)
    case string                     (TokenInfo)
    case setMinus                   (TokenInfo)
    case unicode                    (TokenInfo)
    case character                  (TokenInfo)
    case rangeSeparator             (TokenInfo)
    case bracketedSetLeftDelimiter  (TokenInfo)
    case bracketedSetRightDelimiter (TokenInfo)
    case setSeparator               (TokenInfo)

    case erroneous                  (TokenInfo)
}

struct TokenInfo: Equatable
{
    /*
     *let indexInLine: String.Index
     *let lineNumber: Int
     */

    let representation: String

    init(_ representation: String)
    {
        self.representation = representation
    }

    init(representation: String)
    {
        self.representation = representation
    }
}
