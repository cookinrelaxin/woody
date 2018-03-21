import Foundation

extension ParseTree.RegularDescription: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(rule, possibleRules):
            return indentation+"""
            (regularDescription
                \(rule.print(indentation))
                \(possibleRules.print(indentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Rule: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(identifier, definitionMarker, regex, ruleTerminator):
            return indentation+"""
            (rule
                \(identifier.print(indentation+standardIndentation))
                \(definitionMarker.print(indentation+standardIndentation))
                \(regex.print(indentation+standardIndentation))
                \(ruleTerminator.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.PossibleRules: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(ruleArray):
            if ruleArray.isEmpty { return "(possibleRules ())" }
            var arrayString = ""
            for rule in ruleArray
            {
                arrayString += "\(rule.print(indentation+standardIndentation))\n"
            }
            return indentation+"""
            (possibleRules
                \(arrayString))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Regex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .groupedRegex(groupedRegex):
            return indentation+"""
            (regex
                \(groupedRegex.print(indentation+standardIndentation)))
            """
        case let .ungroupedRegex(ungroupedRegex):
            return indentation+"""
            (regex
                \(ungroupedRegex.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.GroupedRegex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(groupLeftDelimiter, regex, groupRightDelimiter,
        repetitionOperator):
            if repetitionOperator == nil
            {
                return indentation+"""
                (groupedRegex
                    \(groupLeftDelimiter.print(indentation+standardIndentation))
                    \(regex.print(indentation+standardIndentation))
                    \(groupRightDelimiter.print(indentation+standardIndentation)))
                """
            }

            return indentation+"""
            (groupedRegex
                \(groupLeftDelimiter.print(indentation+standardIndentation))
                \(regex.print(indentation+standardIndentation))
                \(groupRightDelimiter.print(indentation+standardIndentation))
                \(repetitionOperator!.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.UngroupedRegex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .union(union):
            return indentation+"""
            (ungroupedRegex
                \(union.print(indentation+standardIndentation)))
            """
        case let .simpleRegex(simpleRegex):
            return indentation+"""
            (ungroupedRegex
                \(simpleRegex.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Union: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(simpleRegex, unionOperator, regex):
            return indentation+"""
            (union
                \(simpleRegex.print(indentation+standardIndentation))
                \(unionOperator.print(indentation+standardIndentation))
                \(regex.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.SimpleRegex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .concatenation(concatenation):
            return indentation+"""
            (simpleRegex
                \(concatenation.print(indentation+standardIndentation)))
            """

        case let .basicRegex(basicRegex):
            return indentation+"""
            (simpleRegex
                \(basicRegex.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Concatenation: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(basicRegex, simpleRegex):
            return indentation+"""
            (concatenation
                \(basicRegex.print(indentation+standardIndentation))
                \(simpleRegex.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.BasicRegex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(elementaryRegex, repetitionOperator):
            if repetitionOperator == nil
            {
                return indentation+"""
                (basicRegex
                    \(elementaryRegex.print(indentation+standardIndentation)))
                """
            }
            return indentation+"""
            (basicRegex
                \(elementaryRegex.print(indentation+standardIndentation))
                \(repetitionOperator!.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.ElementaryRegex: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .string(string):
            return indentation+"""
            (elementaryRegex
                \(string.print(indentation+standardIndentation)))
            """

        case let .identifier(identifier):
            return indentation+"""
            (elementaryRegex
                \(identifier.print(indentation+standardIndentation)))
            """

        case let .set(set):
            return indentation+"""
            (elementaryRegex
                \(set.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.DefinitionMarker: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .helperDefinitionMarker(helperDefinitionMarker):
            return indentation+"""
            (definitionMarker
                \(helperDefinitionMarker.print(indentation+standardIndentation)))
            """

        case let .tokenDefinitionMarker(tokenDefinitionMarker):
            return indentation+"""
            (definitionMarker
                \(tokenDefinitionMarker.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.RepetitionOperator: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .zeroOrMoreOperator(zeroOrMoreOperator):
            return indentation+"""
            (repetitionOperator
                \(zeroOrMoreOperator.print(indentation+standardIndentation)))
            """

        case let .oneOrMoreOperator(oneOrMoreOperator):
            return indentation+"""
            (repetitionOperator
                \(oneOrMoreOperator.print(indentation+standardIndentation)))
            """

        case let .zeroOrOneOperator(zeroOrOneOperator):
            return indentation+"""
            (repetitionOperator
                \(zeroOrOneOperator.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Set: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(simpleSet, setSubtraction):
            if setSubtraction == nil
            {
                return indentation+"""
                (set
                    \(simpleSet.print(indentation+standardIndentation)))
                """
            }
                return indentation+"""
                (set
                    \(simpleSet.print(indentation+standardIndentation))
                    \(setSubtraction!.print(indentation+standardIndentation)))
                """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.SetSubtraction: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(setMinus, simpleSet):
            return indentation+"""
            (setSubtraction
                \(setMinus.print(indentation+standardIndentation))
                \(simpleSet.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.SimpleSet: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .standardSet(standardSet):
            return indentation+"""
            (simpleSet
                \(standardSet.print(indentation+standardIndentation)))
            """
        case let .literalSet(literalSet):
            return indentation+"""
            (simpleSet
                \(literalSet.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.StandardSet: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(unicode):
            return indentation+"""
            (standardSet
                \(unicode.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.LiteralSet: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .basicSet(basicSet):
            return indentation+"""
            (literalSet
                \(basicSet.print(indentation+standardIndentation)))
            """
        case let .bracketedSet(bracketedSet):
            return indentation+"""
            (literalSet
                \(bracketedSet.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.BasicSet: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .range(range):
            return indentation+"""
            (basicSet
                \(range.print(indentation+standardIndentation)))
            """

        case let .character(character):
            return indentation+"""
            (basicSet
                \(character.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.BracketedSet: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(bracketedSetLeftDelimiter, basicSetList,
        bracketedSetRightDelimiter):
            return indentation+"""
            (bracketedSet
                \(bracketedSetLeftDelimiter.print(indentation+standardIndentation))
                \(basicSetList.print(indentation+standardIndentation))
                \(bracketedSetRightDelimiter.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.BasicSetList: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .basicSets(basicSets):
            return indentation+"""
            (basicSetList
                \(basicSets.print(indentation+standardIndentation)))
            """

        case let .basicSet(basicSet):
            return indentation+"""
            (basicSetList
                \(basicSet.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.BasicSets: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(basicSet, setSeparator, basicSetList):
            return indentation+"""
            (basicSets
                \(basicSet.print(indentation+standardIndentation))
                \(setSeparator.print(indentation+standardIndentation))
                \(basicSetList.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}

extension ParseTree.Range: SEXPPrintable
{
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(character_1, rangeSeparator, character_2):
            return indentation+"""
            (range
                \(character_1.print(indentation+standardIndentation))
                \(rangeSeparator.print(indentation+standardIndentation))
                \(character_2.print(indentation+standardIndentation)))
            """
        }
    }

    var debugDescription: Swift.String { return print("") }
}
