import Foundation

struct CharacterSet: Equatable, Hashable
{
    let positiveSet: Set<ScalarRange>
    let negativeSet: Set<ScalarRange>

    init(_ scalar: Scalar)
    {
        positiveSet = Set([ScalarRange(scalar)])
        negativeSet = Set()
    }

    init(pSet: ParseTree.Set, _ context: Context)
    {
        switch pSet
        {
        case let .cat(pSimpleSet, pSetSubtraction):
            self.positiveSet = CharacterSet._set(for: pSimpleSet, context)
            self.negativeSet = CharacterSet._set(for: pSetSubtraction,
                context)
        }
    }

    func contains(_ r: ElementaryRange) -> Bool
    {
        func contained(in set: Set<ScalarRange>) -> Bool
        { return set.contains { $0.contains(r) } }

        return contained(in: positiveSet) && !contained(in: negativeSet)
    }

    private static func _set(for pSimpleSet: ParseTree.SimpleSet, _ context:
        Context)
    -> Set<ScalarRange>
    {
        switch pSimpleSet
        {
            case let .standardSet(pStandardSet):
                return CharacterSet._set(for: pStandardSet, context)
            case let .literalSet(pLiteralSet):
                return CharacterSet._set(for: pLiteralSet, context)
        }
    }

    private static func _set(for pStandardSet: ParseTree.StandardSet, _
        context: Context) -> Set<ScalarRange>
    {
        let range = Scalar(UInt32(0))! ... Scalar(UInt32(0x100_000))!

        switch pStandardSet
        {
            case .cat(_): return Set([ScalarRange(range)])
        }
    }

    private static func _set(for pLiteralSet: ParseTree.LiteralSet, _
        context: Context) -> Set<ScalarRange>
    {
        switch pLiteralSet
        {
            case let .basicSet(pBasicSet):
                return CharacterSet._set(for: pBasicSet, context)

            case let .bracketedSet(pBracketedSet):
                return CharacterSet._set(for: pBracketedSet, context)
        }
    }

    private static func _set(for pBasicSet: ParseTree.BasicSet, _ context:
        Context) -> Set<ScalarRange>
    {
        switch pBasicSet
        {
            case let .range(pRange):
                return CharacterSet._set(for: pRange, context)

            case let .character(pCharacter):
                return CharacterSet._set(for: pCharacter, context)
        }
    }

    private static func _set(for pBracketedSet: ParseTree.BracketedSet, _
        context: Context) ->
    Set<ScalarRange>
    {
        switch pBracketedSet
        {
            case let .cat(_, pBasicSetList, _):
                return CharacterSet._set(for: pBasicSetList, context)
        }
    }

    private static func _set(for pBasicSetList: ParseTree.BasicSetList, _
        context: Context) -> Set<ScalarRange>
    {
        switch pBasicSetList
        {
            case let .basicSets(pBasicSets):
                return CharacterSet._set(for: pBasicSets, context)

            case let .basicSet(pBasicSet):
                return CharacterSet._set(for: pBasicSet, context)
        }
    }

    private static func _set(for pBasicSets: ParseTree.BasicSets, _ context:
        Context) -> Set<ScalarRange>
    {
        switch pBasicSets
        {
            case let .cat(pBasicSet, _, pBasicSetList):
                return CharacterSet._set(for: pBasicSet,
                    context).union(CharacterSet._set(for: pBasicSetList,
    context))
        }
    }

    private static func _set(for pRange: ParseTree.Range,
                             _ context: Context) -> Set<ScalarRange>
    {
        switch pRange
        {
            case let .cat(c1, _, c2):
                let s1 = toScalar(c1)
                let s2 = toScalar(c2)

                return Set([ScalarRange(s1...s2)])
        }
    }

    private static func _set(for lCharacter: Lexer.Character, _ context:
        Context) -> Set<ScalarRange>
    {
        return Set([ScalarRange(toScalar(lCharacter))])
    }

    private static func _set(for pSetSubtraction: ParseTree.SetSubtraction?,
_ context: Context)
    -> Set<ScalarRange>
    {
        guard let pSetSubtraction = pSetSubtraction
        else { return Set<ScalarRange>() }

        switch pSetSubtraction
        {
            case let .cat(_, pSimpleSet): return CharacterSet._set(for:
                pSimpleSet, context)
        }
    }
}

extension CharacterSet: SEXPPrintable
{
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
