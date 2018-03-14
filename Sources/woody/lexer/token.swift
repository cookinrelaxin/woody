enum Token: Equatable
{
    case identifier       (TokenInfo)
    case helperArrow      (TokenInfo)
    case tokenArrow       (TokenInfo)
    case semicolon        (TokenInfo)
    case leftParenthesis  (TokenInfo)
    case rightParenthesis (TokenInfo)
    case bar              (TokenInfo)
    case star             (TokenInfo)
    case plus             (TokenInfo)
    case question         (TokenInfo)
    case caret            (TokenInfo)
    case dollar           (TokenInfo)
    case string           (TokenInfo)
    case unicode          (TokenInfo)
    case ascii            (TokenInfo)
    case character        (TokenInfo)
    case leftBracket      (TokenInfo)
    case rightBracket     (TokenInfo)
    case setSeparator     (TokenInfo)
    case dash             (TokenInfo)
    case erroneous        (TokenInfo)
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
