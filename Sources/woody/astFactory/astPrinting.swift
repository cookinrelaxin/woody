import Foundation

extension AbstractSyntaxTree: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let i = indentation+standardIndentation
        let rulesSexp = rules.reduce("")
        { $0 + "\($1.sexp(i))" + "\n" }

        let sexp = indentation+"""
        (ast
        \(rulesSexp))
        """

        return sexp
    }
}

extension AST.TokenDefinition: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let i = indentation+standardIndentation
        let sexp = indentation+"""
        (rule \(tokenClass)
        \(regex.sexp(i)))
        """

        return sexp
    }
}

extension AST.Regex: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        if let r = repetitionOperator
        {
            return indentation+"""
            (\(r.sexp(""))
            \(basicRegex.sexp(indentation+standardIndentation)))
            """
        }
        return basicRegex.sexp(indentation)
    }
}

extension AST.BasicRegex: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        switch self
        {
        case let .regex(regex):
            return regex.sexp(indentation)

        case .epsilon:
            return indentation+"ε"

        case let .union(r1, r2):
            let i = indentation+standardIndentation
            return indentation+"""
            (∪
            \(r1.sexp(i))
            \(r2.sexp(i)))
            """

        case let .concatenation(r1, r2):
            let i = indentation+standardIndentation
            return indentation+"""
            (cat
            \(r1.sexp(i))
            \(r2.sexp(i)))
            """
        case let .characterSet(c):
            return c.sexp(indentation)
        }
    }
}

extension AST.RepetitionOperator: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let i = indentation
        switch self
        {
        case .zeroOrOne  : return "\(i)?"
        case .zeroOrMore : return "\(i)*"
        case .oneOrMore  : return "\(i)+"
        }
    }
}

extension AST.CharacterSet: SEXPPrintable
{
    /*
     *let positiveSet: Set<ScalarRange>
     *let negativeSet: Set<ScalarRange>
     */

    func sexp(_ indentation: String) -> String
    {
        let i1 = indentation+standardIndentation
        let i2 = i1+standardIndentation
        let pScalars: String
        let nScalars: String

        if positiveSet.isEmpty { pScalars = i1+"(positiveSet ())" }
        else if positiveSet.count == 1
        {
            pScalars = i1+"(positiveSet \(positiveSet.first!.sexp("")))"
        }
        else
        {
            pScalars = positiveSet.reduce(i1+"(positiveSet"+"\n")
            { sexpStr, scalarRange in
                sexpStr+scalarRange.sexp(i2)+"\n"
            }.dropLast() + ")"
        }

        if negativeSet.isEmpty { nScalars = i1+"(negativeSet ())" }
        else if negativeSet.count == 1
        {
            nScalars = i1+"(negativeSet \(negativeSet.first!.sexp("")))"
        }
        else
        {
            nScalars = negativeSet.reduce(i1+"(negativeSet"+"\n")
            { sexpStr, scalarRange in
                sexpStr+scalarRange.sexp(i2)+"\n"
            }.dropLast() + ")"
        }

        return indentation+"""
        (characterSet
        \(pScalars)
        \(nScalars))
        """
    }
}

extension ScalarRange: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let l = String(format: "U+%X", lowerBound.value)
        let u = String(format: "U+%X", upperBound.value)

        if lowerBound == upperBound
        {
            return "\(indentation)\(l)"
        }

        return "\(indentation)(scalarRange \(l) \(u))"
    }
}
