import Foundation

extension WoodyLexer.Identifier: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(identifier \(info))"
    }
}

extension WoodyLexer.HelperDefinitionMarker: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(helperDefinitionMarker \(info))"
    }
}

extension WoodyLexer.TokenDefinitionMarker: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(tokenDefinitionMarker \(info))"
    }
}

extension WoodyLexer.RuleTerminator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(ruleTerminator \(info))"
    }
}

extension WoodyLexer.GroupLeftDelimiter: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(groupLeftDelimiter \(info))"
    }
}

extension WoodyLexer.GroupRightDelimiter: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(groupRightDelimiter \(info))"
    }
}

extension WoodyLexer.UnionOperator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(unionOperator \(info))"
    }
}

extension WoodyLexer.ZeroOrMoreOperator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(zeroOrMoreOperator \(info))"
    }
}

extension WoodyLexer.OneOrMoreOperator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(oneOrMoreOperator \(info))"
    }
}

extension WoodyLexer.ZeroOrOneOperator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(zeroOrOneOperator \(info))"
    }
}

extension WoodyLexer.String: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(string \(info))"
    }
}

extension WoodyLexer.SetMinus: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(setMinus \(info))"
    }
}

extension WoodyLexer.Unicode: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(unicode \(info))"
    }
}

extension WoodyLexer.Character: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(character \(info))"
    }
}

extension WoodyLexer.RangeSeparator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(rangeSeparator \(info))"
    }
}

extension WoodyLexer.BracketedSetLeftDelimiter: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetLeftDelimiter \(info))"
    }
}

extension WoodyLexer.BracketedSetRightDelimiter: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetRightDelimiter \(info))"
    }
}

extension WoodyLexer.SetSeparator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(setSeparator \(info))"
    }
}

extension WoodyLexer.Erroneous: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        return indentation+"(erroneous \(info))"
    }
}
