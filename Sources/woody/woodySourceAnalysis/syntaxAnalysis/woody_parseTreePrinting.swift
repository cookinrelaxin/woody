import Foundation

extension ParseTree.RegularDescription: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(rule, possibleRules):
            return indentation+"""
            (regularDescription
                \(rule.sexp(indentation))
                \(possibleRules.sexp(indentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Rule: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(identifier, definitionMarker, regex, ruleTerminator):
            return indentation+"""
            (rule
                \(identifier.sexp(indentation+standardIndentation))
                \(definitionMarker.sexp(indentation+standardIndentation))
                \(regex.sexp(indentation+standardIndentation))
                \(ruleTerminator.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.PossibleRules: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(ruleArray):
            if ruleArray.isEmpty { return "(possibleRules ())" }
            var arrayString = ""
            for rule in ruleArray
            {
                arrayString += "\(rule.sexp(indentation+standardIndentation))\n"
            }
            return indentation+"""
            (possibleRules
                \(arrayString))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Regex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .groupedRegex(groupedRegex):
            return indentation+"""
            (regex
                \(groupedRegex.sexp(indentation+standardIndentation)))
            """
        case let .ungroupedRegex(ungroupedRegex):
            return indentation+"""
            (regex
                \(ungroupedRegex.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.GroupedRegex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(groupLeftDelimiter, regex, groupRightDelimiter,
        repetitionOperator):
            if repetitionOperator == nil
            {
                return indentation+"""
                (groupedRegex
                    \(groupLeftDelimiter.sexp(indentation+standardIndentation))
                    \(regex.sexp(indentation+standardIndentation))
                    \(groupRightDelimiter.sexp(indentation+standardIndentation)))
                """
            }

            return indentation+"""
            (groupedRegex
                \(groupLeftDelimiter.sexp(indentation+standardIndentation))
                \(regex.sexp(indentation+standardIndentation))
                \(groupRightDelimiter.sexp(indentation+standardIndentation))
                \(repetitionOperator!.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.UngroupedRegex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .union(union):
            return indentation+"""
            (ungroupedRegex
                \(union.sexp(indentation+standardIndentation)))
            """
        case let .simpleRegex(simpleRegex):
            return indentation+"""
            (ungroupedRegex
                \(simpleRegex.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Union: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(simpleRegex, unionOperator, regex):
            return indentation+"""
            (union
                \(simpleRegex.sexp(indentation+standardIndentation))
                \(unionOperator.sexp(indentation+standardIndentation))
                \(regex.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.SimpleRegex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .concatenation(concatenation):
            return indentation+"""
            (simpleRegex
                \(concatenation.sexp(indentation+standardIndentation)))
            """

        case let .basicRegex(basicRegex):
            return indentation+"""
            (simpleRegex
                \(basicRegex.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Concatenation: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(basicRegex, simpleRegex):
            return indentation+"""
            (concatenation
                \(basicRegex.sexp(indentation+standardIndentation))
                \(simpleRegex.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.BasicRegex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(elementaryRegex, repetitionOperator):
            if repetitionOperator == nil
            {
                return indentation+"""
                (basicRegex
                    \(elementaryRegex.sexp(indentation+standardIndentation)))
                """
            }
            return indentation+"""
            (basicRegex
                \(elementaryRegex.sexp(indentation+standardIndentation))
                \(repetitionOperator!.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.ElementaryRegex: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .string(string):
            return indentation+"""
            (elementaryRegex
                \(string.sexp(indentation+standardIndentation)))
            """

        case let .identifier(identifier):
            return indentation+"""
            (elementaryRegex
                \(identifier.sexp(indentation+standardIndentation)))
            """

        case let .set(set):
            return indentation+"""
            (elementaryRegex
                \(set.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.DefinitionMarker: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .helperDefinitionMarker(helperDefinitionMarker):
            return indentation+"""
            (definitionMarker
                \(helperDefinitionMarker.sexp(indentation+standardIndentation)))
            """

        case let .tokenDefinitionMarker(tokenDefinitionMarker):
            return indentation+"""
            (definitionMarker
                \(tokenDefinitionMarker.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.RepetitionOperator: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .zeroOrMoreOperator(zeroOrMoreOperator):
            return indentation+"""
            (repetitionOperator
                \(zeroOrMoreOperator.sexp(indentation+standardIndentation)))
            """

        case let .oneOrMoreOperator(oneOrMoreOperator):
            return indentation+"""
            (repetitionOperator
                \(oneOrMoreOperator.sexp(indentation+standardIndentation)))
            """

        case let .zeroOrOneOperator(zeroOrOneOperator):
            return indentation+"""
            (repetitionOperator
                \(zeroOrOneOperator.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Set: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(simpleSet, setSubtraction):
            if setSubtraction == nil
            {
                return indentation+"""
                (set
                    \(simpleSet.sexp(indentation+standardIndentation)))
                """
            }
                return indentation+"""
                (set
                    \(simpleSet.sexp(indentation+standardIndentation))
                    \(setSubtraction!.sexp(indentation+standardIndentation)))
                """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.SetSubtraction: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(setMinus, simpleSet):
            return indentation+"""
            (setSubtraction
                \(setMinus.sexp(indentation+standardIndentation))
                \(simpleSet.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.SimpleSet: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .standardSet(standardSet):
            return indentation+"""
            (simpleSet
                \(standardSet.sexp(indentation+standardIndentation)))
            """
        case let .literalSet(literalSet):
            return indentation+"""
            (simpleSet
                \(literalSet.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.StandardSet: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(unicode):
            return indentation+"""
            (standardSet
                \(unicode.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.LiteralSet: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .basicSet(basicSet):
            return indentation+"""
            (literalSet
                \(basicSet.sexp(indentation+standardIndentation)))
            """
        case let .bracketedSet(bracketedSet):
            return indentation+"""
            (literalSet
                \(bracketedSet.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.BasicSet: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .range(range):
            return indentation+"""
            (basicSet
                \(range.sexp(indentation+standardIndentation)))
            """

        case let .character(character):
            return indentation+"""
            (basicSet
                \(character.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.BracketedSet: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(bracketedSetLeftDelimiter, basicSetList,
        bracketedSetRightDelimiter):
            return indentation+"""
            (bracketedSet
                \(bracketedSetLeftDelimiter.sexp(indentation+standardIndentation))
                \(basicSetList.sexp(indentation+standardIndentation))
                \(bracketedSetRightDelimiter.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.BasicSetList: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .basicSets(basicSets):
            return indentation+"""
            (basicSetList
                \(basicSets.sexp(indentation+standardIndentation)))
            """

        case let .basicSet(basicSet):
            return indentation+"""
            (basicSetList
                \(basicSet.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.BasicSets: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(basicSet, setSeparator, basicSetList):
            return indentation+"""
            (basicSets
                \(basicSet.sexp(indentation+standardIndentation))
                \(setSeparator.sexp(indentation+standardIndentation))
                \(basicSetList.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}

extension ParseTree.Range: SEXPPrintable
{
    func sexp(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(character_1, rangeSeparator, character_2):
            return indentation+"""
            (range
                \(character_1.sexp(indentation+standardIndentation))
                \(rangeSeparator.sexp(indentation+standardIndentation))
                \(character_2.sexp(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return sexp("") }
}
