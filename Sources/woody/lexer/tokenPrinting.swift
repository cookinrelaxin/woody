import Foundation

extension Lexer.Identifier: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(identifier \(info))"
    }
}

extension Lexer.HelperDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(helperDefinitionMarker \(info))"
    }
}

extension Lexer.TokenDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(tokenDefinitionMarker \(info))"
    }
}

extension Lexer.RuleTerminator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(ruleTerminator \(info))"
    }
}

extension Lexer.GroupLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(groupLeftDelimiter \(info))"
    }
}

extension Lexer.GroupRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(groupRightDelimiter \(info))"
    }
}

extension Lexer.UnionOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(unionOperator \(info))"
    }
}

extension Lexer.ZeroOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(zeroOrMoreOperator \(info))"
    }
}

extension Lexer.OneOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(oneOrMoreOperator \(info))"
    }
}

extension Lexer.ZeroOrOneOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(zeroOrOneOperator \(info))"
    }
}

extension Lexer.String: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(string \(info))"
    }
}

extension Lexer.SetMinus: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(setMinus \(info))"
    }
}

extension Lexer.Unicode: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(unicode \(info))"
    }
}

extension Lexer.Character: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(character \(info))"
    }
}

extension Lexer.RangeSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(rangeSeparator \(info))"
    }
}

extension Lexer.BracketedSetLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetLeftDelimiter \(info))"
    }
}

extension Lexer.BracketedSetRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetRightDelimiter \(info))"
    }
}

extension Lexer.SetSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(setSeparator \(info))"
    }
}

extension Lexer.Erroneous: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(erroneous \(info))"
    }
}
