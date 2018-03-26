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
        let i = indentation+standardIndentation

        switch self
        {
        case .ε: return indentation+"ε"

        case let .oneOrMore(r): return indentation+"(+ \(r.sexp(i)))"

        case let .union(r1, r2):
            return indentation+"""
            (∪
            \(r1.sexp(i))
            \(r2.sexp(i)))
            """

        case let .concatenation(r1, r2):
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
