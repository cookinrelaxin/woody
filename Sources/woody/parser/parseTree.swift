import Foundation

extension Parser
{
    struct ParseTree: Equatable
    {
        let regularDescription: RegularDescription

        init(_ regularDescription: RegularDescription)
        {
            self.regularDescription = regularDescription
        }
    }

    indirect enum RegularDescription: Nonterminal, Equatable
    {
        case cat(Rule, PossibleRules)
    }

    indirect enum Rule: Nonterminal, Equatable
    {
        case cat(Lexer.Identifier, DefinitionMarker, Regex, Lexer.RuleTerminator)
    }

    indirect enum PossibleRules: Nonterminal, Equatable
    {
        case cat([Rule])
    }

    indirect enum Regex: Nonterminal, Equatable
    {
        case groupedRegex(GroupedRegex)
        case ungroupedRegex(UngroupedRegex)
    }

    indirect enum GroupedRegex: Nonterminal, Equatable
    {
        case cat(Lexer.GroupLeftDelimiter, Regex, Lexer.GroupRightDelimiter,
            RepetitionOperator?)
    }

    indirect enum UngroupedRegex: Nonterminal, Equatable
    {
        case union(Union)
        case simpleRegex(SimpleRegex)
    }

    indirect enum Union: Nonterminal, Equatable
    {
        case cat(SimpleRegex, Lexer.UnionOperator, Regex)
    }

    indirect enum SimpleRegex: Nonterminal, Equatable
    {
        case concatenation(Concatenation)
        case basicRegex(BasicRegex)
    }

    indirect enum Concatenation: Nonterminal, Equatable
    {
        case cat(BasicRegex, SimpleRegex)
    }

    indirect enum BasicRegex: Nonterminal, Equatable
    {
        case cat(ElementaryRegex, RepetitionOperator?)
    }

    indirect enum ElementaryRegex: Nonterminal, Equatable
    {
        case string(Lexer.String)
        case identifier(Lexer.Identifier)
        case set(Set)
    }

    indirect enum DefinitionMarker: Nonterminal, Equatable
    {
        case helperDefinitionMarker(Lexer.HelperDefinitionMarker)
        case tokenDefinitionMarker(Lexer.TokenDefinitionMarker)
    }

    indirect enum RepetitionOperator: Nonterminal, Equatable
    {
        case zeroOrMoreOperator(Lexer.ZeroOrMoreOperator)
        case oneOrMoreOperator(Lexer.OneOrMoreOperator)
        case zeroOrOneOperator(Lexer.ZeroOrOneOperator)
    }

    indirect enum Set: Nonterminal, Equatable
    {
        case cat(SimpleSet, SetSubtraction?)
    }

    indirect enum SetSubtraction: Nonterminal, Equatable
    {
        case cat(Lexer.SetMinus, SimpleSet)
    }

    indirect enum SimpleSet: Nonterminal, Equatable
    {
        case standardSet(StandardSet)
        case literalSet(LiteralSet)
    }

    indirect enum StandardSet: Nonterminal, Equatable
    {
        case cat(Lexer.Unicode)
    }

    indirect enum LiteralSet: Nonterminal, Equatable
    {
        case basicSet(BasicSet)
        case bracketedSet(BracketedSet)
    }

    indirect enum BasicSet: Nonterminal, Equatable
    {
        case range(Range)
        case character(Lexer.Character)
    }

    indirect enum BracketedSet: Nonterminal, Equatable
    {
        case cat(Lexer.BracketedSetLeftDelimiter, BasicSetList,
            Lexer.BracketedSetRightDelimiter)
    }

    indirect enum BasicSetList: Nonterminal, Equatable
    {
        case basicSets(BasicSets)
        case basicSet(BasicSet)
    }
    indirect enum BasicSets: Nonterminal, Equatable
    {
        case cat(BasicSet, Lexer.SetSeparator, BasicSetList)
    }

    indirect enum Range: Nonterminal, Equatable
    {
        case cat(Lexer.Character, Lexer.RangeSeparator, Lexer.Character)
    }
}
