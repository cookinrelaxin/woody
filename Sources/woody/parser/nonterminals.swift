import Foundation

let standardIndentation = " "

protocol Nonterminal
{
    func isEqualTo(_ other: Nonterminal) -> Bool
    var asEquatable: AnyNonterminal { get }
}

extension Nonterminal where Self: Equatable
{
    func isEqualTo(_ other: Nonterminal) -> Bool
    {
        guard let other = other as? Self else { return false }
        return self == other
    }

    var asEquatable: AnyNonterminal { return AnyNonterminal(self) }
}

struct AnyNonterminal
{
    init(_ nonterminal: Nonterminal) { self.nonterminal = nonterminal }

    fileprivate let nonterminal: Nonterminal
}

extension AnyNonterminal: Equatable
{
    static func ==(lhs: AnyNonterminal, rhs: AnyNonterminal) -> Bool
    {
        return lhs.nonterminal.isEqualTo(rhs.nonterminal)
    }
}

indirect enum RegularDescription: Nonterminal, Equatable
{
    case cat(Rule, PossibleRules)

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
}

extension RegularDescription: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Rule: Nonterminal, Equatable
{
    case cat(Identifier, DefinitionMarker, Regex, RuleTerminator)
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
}

extension Rule: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum PossibleRules: Nonterminal, Equatable
{
    case cat([Rule])
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
}

extension PossibleRules: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Regex: Nonterminal, Equatable
{
    case groupedRegex(GroupedRegex)
    case ungroupedRegex(UngroupedRegex)
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
}

extension Regex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum GroupedRegex: Nonterminal, Equatable
{
    case cat(GroupLeftDelimiter, Regex, GroupRightDelimiter)
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .cat(groupLeftDelimiter, regex, groupRightDelimiter):
            return indentation+"""
            (groupedRegex
                \(groupLeftDelimiter.print(indentation+standardIndentation))
                \(regex.print(indentation+standardIndentation))
                \(groupRightDelimiter.print(indentation+standardIndentation)))
            """
        }
    }
}

extension GroupedRegex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum UngroupedRegex: Nonterminal, Equatable
{
    case union(Union)
    case simpleRegex(SimpleRegex)
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
}

extension UngroupedRegex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Union: Nonterminal, Equatable
{
    case cat(SimpleRegex, UnionOperator, Regex)
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
}

extension Union: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum SimpleRegex: Nonterminal, Equatable
{
    case concatenation(Concatenation)
    case basicRegex(BasicRegex)
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
}

extension SimpleRegex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Concatenation: Nonterminal, Equatable
{
    case cat(BasicRegex, SimpleRegex)
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
}

extension Concatenation: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum BasicRegex: Nonterminal, Equatable
{
    case cat(ElementaryRegex, RepetitionOperator?)
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
}

extension BasicRegex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum ElementaryRegex: Nonterminal, Equatable
{
    case positionOperator(PositionOperator)
    case string(String)
    case identifier(Identifier)
    case set(Set)
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .positionOperator(positionOperator):
            return indentation+"""
            (elementaryRegex
                \(positionOperator.print(indentation+standardIndentation)))
            """

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
}

extension ElementaryRegex: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum DefinitionMarker: Nonterminal, Equatable
{
    case helperDefinitionMarker(HelperDefinitionMarker)
    case tokenDefinitionMarker(TokenDefinitionMarker)
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
}

extension DefinitionMarker: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum RepetitionOperator: Nonterminal, Equatable
{
    case zeroOrMoreOperator(ZeroOrMoreOperator)
    case oneOrMoreOperator(OneOrMoreOperator)
    case zeroOrOneOperator(ZeroOrOneOperator)
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
}

extension RepetitionOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum PositionOperator: Nonterminal, Equatable
{
    case lineHeadOperator(LineHeadOperator)
    case lineTailOperator(LineTailOperator)
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .lineHeadOperator(lineHeadOperator):
            return indentation+"""
            (positionOperator
                \(lineHeadOperator.print(indentation+standardIndentation)))
            """

        case let .lineTailOperator(lineTailOperator):
            return indentation+"""
            (positionOperator
                \(lineTailOperator.print(indentation+standardIndentation)))
            """
        }
    }
}

extension PositionOperator: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Set: Nonterminal, Equatable
{
    case cat(SimpleSet, SetSubtraction?)
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
}

extension Set: CustomDebugStringConvertible {
    var debugDescription: Swift.String { return print("") }
}

indirect enum SetSubtraction: Nonterminal, Equatable
{
    case cat(SetMinus, SimpleSet)
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
}

extension SetSubtraction: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum SimpleSet: Nonterminal, Equatable
{
    case standardSet(StandardSet)
    case literalSet(LiteralSet)
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
}

extension SimpleSet: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum StandardSet: Nonterminal, Equatable
{
    case cat(Unicode)
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
}

extension StandardSet: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum LiteralSet: Nonterminal, Equatable
{
    case basicSet(BasicSet)
    case bracketedSet(BracketedSet)
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
}

extension LiteralSet: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum BasicSet: Nonterminal, Equatable
{
    case character(Character)
    case range(Range)
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .character(character):
            return indentation+"""
            (basicSet
                \(character.print(indentation+standardIndentation)))
            """

        case let .range(range):
            return indentation+"""
            (range
                \(range.print(indentation+standardIndentation)))
            """
        }
    }
}

extension BasicSet: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum BracketedSet: Nonterminal, Equatable
{
    case cat(BracketedSetLeftDelimiter, BasicSetList,
        BracketedSetRightDelimiter)
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
}

extension BracketedSet: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum BasicSetList: Nonterminal, Equatable
{
    case basicSet(BasicSet)
    case basicSets(BasicSets)
    func print(_ indentation: Swift.String) -> Swift.String
    {
        switch self
        {
        case let .basicSet(basicSet):
            return indentation+"""
            (basicSetList
                \(basicSet.print(indentation+standardIndentation)))
            """

        case let .basicSets(basicSets):
            return indentation+"""
            (basicSetList
                \(basicSets.print(indentation+standardIndentation)))
            """
        }
    }
}

extension BasicSetList: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum BasicSets: Nonterminal, Equatable
{
    case cat(BasicSet, SetSeparator, BasicSetList)
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
}

extension BasicSets: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}

indirect enum Range: Nonterminal, Equatable
{
    case cat(Character, RangeSeparator, Character)
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
}

extension Range: CustomDebugStringConvertible
{
    var debugDescription: Swift.String { return print("") }
}
