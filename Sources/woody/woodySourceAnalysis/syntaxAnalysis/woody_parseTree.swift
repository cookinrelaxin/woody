import Foundation

struct WoodyParseTree: Equatable
{
    let regularDescription: RegularDescription

    init(_ regularDescription: RegularDescription)
    {
        self.regularDescription = regularDescription
    }

    indirect enum RegularDescription: Nonterminal, Equatable, Hashable
    {
        case cat(Rule, PossibleRules)
    }

    indirect enum Rule: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.Identifier, DefinitionMarker, Regex, Lexer.RuleTerminator)
    }

    indirect enum PossibleRules: Nonterminal, Equatable, Hashable
    {
        case cat([Rule])

        var hashValue: Int
        {
            switch self
            {
            case let .cat(rules): return rules.count
            }
        }
    }

    indirect enum Regex: Nonterminal, Equatable, Hashable
    {
        case groupedRegex(GroupedRegex)
        case ungroupedRegex(UngroupedRegex)
    }

    indirect enum GroupedRegex: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.GroupLeftDelimiter, Regex, Lexer.GroupRightDelimiter,
            RepetitionOperator?)

        var hashValue: Int
        {
            switch self
            {
                case let .cat(groupLeftDelimiter, regex, groupRightDelimiter, _):
                    return groupLeftDelimiter.hashValue ^ regex.hashValue ^
                    groupRightDelimiter.hashValue
            }
        }
    }

    indirect enum UngroupedRegex: Nonterminal, Equatable, Hashable
    {
        case union(Union)
        case simpleRegex(SimpleRegex)
    }

    indirect enum Union: Nonterminal, Equatable, Hashable
    {
        case cat(SimpleRegex, Lexer.UnionOperator, Regex)
    }

    indirect enum SimpleRegex: Nonterminal, Equatable, Hashable
    {
        case concatenation(Concatenation)
        case basicRegex(BasicRegex)
    }

    indirect enum Concatenation: Nonterminal, Equatable, Hashable
    {
        case cat(BasicRegex, SimpleRegex)
    }

    indirect enum BasicRegex: Nonterminal, Equatable, Hashable
    {
        case cat(ElementaryRegex, RepetitionOperator?)

        var hashValue: Int
        {
            switch self
            {
                case let .cat(elementaryRegex, _):
                    return elementaryRegex.hashValue
            }
        }
    }

    indirect enum ElementaryRegex: Nonterminal, Equatable, Hashable
    {
        case string(Lexer.String)
        case identifier(Lexer.Identifier)
        case set(Set)
    }

    indirect enum DefinitionMarker: Nonterminal, Equatable, Hashable
    {
        case helperDefinitionMarker(Lexer.HelperDefinitionMarker)
        case tokenDefinitionMarker(Lexer.TokenDefinitionMarker)
    }

    indirect enum RepetitionOperator: Nonterminal, Equatable, Hashable
    {
        case zeroOrMoreOperator(Lexer.ZeroOrMoreOperator)
        case oneOrMoreOperator(Lexer.OneOrMoreOperator)
        case zeroOrOneOperator(Lexer.ZeroOrOneOperator)
    }

    indirect enum Set: Nonterminal, Equatable, Hashable
    {
        case cat(SimpleSet, SetSubtraction?)

        var hashValue: Int
        {
            switch self
            {
            case let .cat(simpleSet, _):
                return simpleSet.hashValue
            }
        }
    }

    indirect enum SetSubtraction: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.SetMinus, SimpleSet)
    }

    indirect enum SimpleSet: Nonterminal, Equatable, Hashable
    {
        case standardSet(StandardSet)
        case literalSet(LiteralSet)
    }

    indirect enum StandardSet: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.Unicode)
    }

    indirect enum LiteralSet: Nonterminal, Equatable, Hashable
    {
        case basicSet(BasicSet)
        case bracketedSet(BracketedSet)
    }

    indirect enum BasicSet: Nonterminal, Equatable, Hashable
    {
        case range(Range)
        case character(Lexer.Character)
    }

    indirect enum BracketedSet: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.BracketedSetLeftDelimiter, BasicSetList,
            Lexer.BracketedSetRightDelimiter)
    }

    indirect enum BasicSetList: Nonterminal, Equatable, Hashable
    {
        case basicSets(BasicSets)
        case basicSet(BasicSet)
    }
    indirect enum BasicSets: Nonterminal, Equatable, Hashable
    {
        case cat(BasicSet, Lexer.SetSeparator, BasicSetList)
    }

    indirect enum Range: Nonterminal, Equatable, Hashable
    {
        case cat(Lexer.Character, Lexer.RangeSeparator, Lexer.Character)
    }
}
