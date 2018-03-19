import Foundation

typealias Nonterminal     = String
typealias DottedItem      = Parser.Regex
typealias ItemSet         = Set<DottedItem>
typealias NonterminalDict = [Nonterminal: ItemSet]
typealias CharacterClass  = Set<Range<Scalar>>
typealias TransitionTable = [(ItemSet, CharacterClass) : ItemSet]
typealias ScalarString = String.UnicodeScalarView

extension LexerGenerator
{
    func relevantCharacterClasses(for itemSet: ItemSet,
                                  nonterminalDict: NonterminalDict)
    -> [CharacterClass]
    {
    }

    func initialItemSet(for nonterminalDict: NonterminalDict) -> ItemSet
    {
        return nonterminalDict.values
    }

    func buildTransitionTable(for nonterminalDict: NonterminalDict)
    -> TransitionTable
    {
        var transitionTable = TransitionTable()
        let initialState = initialItemSet(for: nonterminalDict)

        var processedStates = Set<ItemSet>()
        var unprocessedStates = Set<ItemSet>([initialState])

        while let state = unprocessedStates.first
        {
            for cc in relevantCharacterClasses(for: state,
                                               nonterminalDict: nonterminalDict)
            {
                let possiblyNewState = currentState.reduce(ItemSet())
                { newItems, item
                    newItems.union(move(item,
                                        over: cc,
                                        nonterminalDict: nonterminalDict))
                }

                if !processedStates.contains(possiblyNewState),
                case let newState = possiblyNewState
                {
                    unprocessedStates.add(newState)
                    transitionTable[(state, cc)] = newState
                }
            }

            processedStates.add(state)
        }

        return transitionTable
    }
}

extension LexerGenerator
{
    func expand(_ item: Parser.Regex,
                for repetitionOperator: RepetitionOperator?) -> ItemSet
    {
        guard let repetitionOperator = repetitionOperator
        else { return ItemSet([item]) }

        /*TODO*/
    }
}

extension LexerGenerator
{
    func move(_ item: Parser.Regex,
              over characterClass: CharacterClass,
              nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch item
        {
        case let .groupedRegex(groupedRegex):
            return move(groupedRegex,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)
        case let .ungroupedRegex(ungroupedRegex):
            return move(ungroupedRegex,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)
        }
    }

    private func move(_ groupedRegex: Parser.GroupedRegex,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch groupedRegex
        {
        case let .cat(_, regex, _, repetitionOperator):
            let rmove = move(regex,
                             over: characterClass,
                             nonterminalDict: nonterminalDict)
            return expand(rmove, for: repetitionOperator)
        }
    }

    private func move(_ ungroupedRegex: Parser.UngroupedRegex,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch ungroupedRegex
        {
        case let .union(union):
            return move(union,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)

        case let .simpleRegex(simpleRegex):
            return move(simpleRegex,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)
        }
    }

    private func move(_ union: Parser.Union,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch union
        {
        case let .cat(simpleRegex, _, regex):
            let smove = move(simpleRegex,
                             over: characterClass,
                             nonterminalDict: nonterminalDict)

            let rmove = move(regex,
                             over: characterClass,
                             nonterminalDict: nonterminalDict)

            return smove.union(rmove)
        }
    }

    private func move(_ simpleRegex: Parser.SimpleRegex,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch simpleRegex
        {
        case let .concatenation(concatenation):
            return move(concatenation,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)

        case let .basicRegex(basicRegex):
            return move(basicRegex,
                        over: characterClass,
                        nonterminalDict: nonterminalDict)
        }
    }

    private func move(_ concatenation: Parser.Concatenation,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch concatenation
        {
        case let .cat(basicRegex, simpleRegex):
            let bmove = move(basicRegex,
                             over: characterClass,
                             nonterminalDict: nonterminalDict)
            return bmove.map
            { item in

            }
        }
    }

    private func move(_ basicRegex: Parser.BasicRegex,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch basicRegex
        {
        }
    }

    private func move(_ elementaryRegex: Parser.ElementaryRegex,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch elementaryRegex
        {
        }
    }

    private func move(_ set: Parser.Set,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch set
        {
        }
    }

    private func move(_ setSubtraction: Parser.SetSubtraction,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch setSubtraction
        {
        }
    }

    private func move(_ simpleSet: Parser.SimpleSet,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch simpleSet
        {
        }
    }

    private func move(_ standardSet: Parser.StandardSet,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch standardSet
        {
        }
    }

    private func move(_ literalSet: Parser.LiteralSet,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch literalSet
        {
        }
    }

    private func move(_ basicSet: Parser.BasicSet,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch basicSet
        {
        }
    }

    private func move(_ bracketedSet: Parser.BracketedSet,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch bracketedSet
        {
        }
    }

    private func move(_ basicSetList: Parser.BasicSetList,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch basicSetList
        {
        }
    }

    private func move(_ basicSets: Parser.BasicSets,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch basicSets
        {
        }
    }

    private func move(_ range: Parser.Range,
                      over characterClass: CharacterClass,
                      nonterminalDict: NonterminalDict) -> ItemSet
    {
        switch range
        {
        }
    }
}

extension Regex
{
    func move(over characterClass: CharacterClass) -> ItemSet
    {
        switch repetitionOperator
        {
        case nil: return basicRegex.move(over: characterClass)

        case zeroOrMore:
            let zero = Regex(basicRegex: .epsilon, repetitionOperator: nil)

            let more = basicRegex.move(over: characterClass)
            .map {
                Regex(basicRegex: .regex($0),
                      repetitionOperator: .zeroOrMore)
            }

            return ItemSet([zero]).union(more)

        case oneOrMore:
            let one = basicRegex.move(over: characterClass).

            let more = basicRegex.move(over: characterClass)
            .map {
                Regex(basicRegex: .regex($0),
                      repetitionOperator: .zeroOrMore)
            }

            return ItemSet([zero]).union(more)
        }
    }
}

extension BasicRegex
{
    func move(over c: CharacterSet) throws -> ItemSet
    {
        switch self
        {
        case let .regex         (regex):
            return regex.move

        case let .epsilon:
            return ItemSet()

        case let .union         (l, r):
            return l.move.union(r.move)

        case let .concatenation (l, r):
            return l.move.map
            { regex in
                Regex(
                    basicRegex: concatenation(regex, r),
                    repetitionOperator: regex.repetitionOperator)
            }

        case let .characterSet  (characterSet):
            if c.isSubset(of: characterSet)
            {
                return ItemSet([Regex(basicRegex: .epsilon,
                                      repetitionOperator: nil)])
            }
            return ItemSet()
        }
    }
}
