import Foundation

extension Lexer.Identifier: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(identifier \(representation))"
    }
}

extension Lexer.HelperDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(helperDefinitionMarker \(representation))"
    }
}

extension Lexer.TokenDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(tokenDefinitionMarker \(representation))"
    }
}

extension Lexer.RuleTerminator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(ruleTerminator \(representation))"
    }
}

extension Lexer.GroupLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(groupLeftDelimiter \(representation))"
    }
}

extension Lexer.GroupRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(groupRightDelimiter \(representation))"
    }
}

extension Lexer.UnionOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(unionOperator \(representation))"
    }
}

extension Lexer.ZeroOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(zeroOrMoreOperator \(representation))"
    }
}

extension Lexer.OneOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(oneOrMoreOperator \(representation))"
    }
}

extension Lexer.ZeroOrOneOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(zeroOrOneOperator \(representation))"
    }
}

extension Lexer.LineHeadOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(lineHeadOperator \(representation))"
    }
}

extension Lexer.LineTailOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(lineTailOperator \(representation))"
    }
}

extension Lexer.String: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(string \(representation))"
    }
}

extension Lexer.SetMinus: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(setMinus \(representation))"
    }
}

extension Lexer.Unicode: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(unicode \(representation))"
    }
}

extension Lexer.Character: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(character \(representation))"
    }
}

extension Lexer.RangeSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(rangeSeparator \(representation))"
    }
}

extension Lexer.BracketedSetLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(bracketedSetLeftDelimiter \(representation))"
    }
}

extension Lexer.BracketedSetRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(bracketedSetRightDelimiter \(representation))"
    }
}

extension Lexer.SetSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(setSeparator \(representation))"
    }
}

extension Lexer.Erroneous: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return "(erroneous \(representation))"
    }
}
