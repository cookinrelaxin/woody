import Foundation

extension Lexer.Identifier: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(identifier \(representation))"
    }
}

extension Lexer.HelperDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(helperDefinitionMarker \(representation))"
    }
}

extension Lexer.TokenDefinitionMarker: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(tokenDefinitionMarker \(representation))"
    }
}

extension Lexer.RuleTerminator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(ruleTerminator \(representation))"
    }
}

extension Lexer.GroupLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(groupLeftDelimiter \(representation))"
    }
}

extension Lexer.GroupRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(groupRightDelimiter \(representation))"
    }
}

extension Lexer.UnionOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(unionOperator \(representation))"
    }
}

extension Lexer.ZeroOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(zeroOrMoreOperator \(representation))"
    }
}

extension Lexer.OneOrMoreOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(oneOrMoreOperator \(representation))"
    }
}

extension Lexer.ZeroOrOneOperator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(zeroOrOneOperator \(representation))"
    }
}

extension Lexer.String: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(string \(representation))"
    }
}

extension Lexer.SetMinus: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(setMinus \(representation))"
    }
}

extension Lexer.Unicode: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(unicode \(representation))"
    }
}

extension Lexer.Character: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(character \(representation))"
    }
}

extension Lexer.RangeSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(rangeSeparator \(representation))"
    }
}

extension Lexer.BracketedSetLeftDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetLeftDelimiter \(representation))"
    }
}

extension Lexer.BracketedSetRightDelimiter: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(bracketedSetRightDelimiter \(representation))"
    }
}

extension Lexer.SetSeparator: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(setSeparator \(representation))"
    }
}

extension Lexer.Erroneous: SEXPPrintable
{
    func print(_ indentation: String) -> String
    {
        return indentation+"(erroneous \(representation))"
    }
}
