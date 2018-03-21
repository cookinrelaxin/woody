import Foundation

fileprivate typealias ScalarString    = String.UnicodeScalarView

fileprivate typealias Rule            = AST.Rule
fileprivate typealias Regex           = AST.Regex
fileprivate typealias BasicRegex      = AST.BasicRegex
fileprivate typealias CharacterSet    = AST.CharacterSet
fileprivate typealias MacroCharacter  = CharacterSet

fileprivate typealias ItemSet         = Set<Regex>
fileprivate typealias TransitionTable = [TransitionPair : ItemSet]

fileprivate struct TransitionPair: Equatable, Hashable
{
    let itemSet: ItemSet
    let macroCharacter: MacroCharacter

    init(_ itemSet: ItemSet, _ macroCharacter: MacroCharacter)
    {
        self.itemSet        = itemSet
        self.macroCharacter = macroCharacter
    }
}

fileprivate extension LexerGenerator
{
    func initialItemSet(for ast: AST) -> ItemSet
    {
        return ast.rules.reduce(ItemSet())
        { $0.union(ItemSet([$1.regex])) }
    }

    func mentionedMacroCharacters(in itemSet: ItemSet) -> Set<MacroCharacter>
    {
        fatalError()
    }

    func buildTransitionTable(for ast: AST) -> TransitionTable
    {
        var transitionTable: TransitionTable = [:]
        let initialState = initialItemSet(for: ast)
        let relevantMacroCharacters = mentionedMacroCharacters(in: initialState)

        var processedStates = Set<ItemSet>()
        var unprocessedStates = Set<ItemSet>([initialState])

        while let state = unprocessedStates.first
        {
            for c in relevantMacroCharacters
            {
                let possiblyNewState = state.reduce(ItemSet())
                { $0.union($1.move(over: c)) }

                if !processedStates.contains(possiblyNewState)
                {
                    unprocessedStates.insert(possiblyNewState)
                    transitionTable[TransitionPair(state, c)] = possiblyNewState
                }
            }

            processedStates.insert(state)
        }

        return transitionTable
    }
}

fileprivate extension AST.Regex
{
    func move(over c: MacroCharacter) -> ItemSet
    {
        guard let repetitionOperator = self.repetitionOperator
        else { return basicRegex.move(over: c) }

        switch repetitionOperator
        {
        case .zeroOrOne:
            return BasicRegex.epsilon.move(over: c)
                .union(Regex(basicRegex: basicRegex,
                             repetitionOperator: nil).move(over: c))

        case .zeroOrMore:
            return BasicRegex.epsilon.move(over: c)
                .union(Regex(basicRegex: basicRegex,
                             repetitionOperator: .oneOrMore).move(over: c))

        case .oneOrMore:
            return Regex(
                basicRegex:
                    BasicRegex.concatenation(
                        Regex(
                            basicRegex: basicRegex,
                            repetitionOperator: nil),
                        Regex(
                            basicRegex: basicRegex,
                            repetitionOperator: .zeroOrMore)),
                repetitionOperator: nil).move(over: c)
        }
    }
}

fileprivate extension AST.BasicRegex
{
    func move(over c: MacroCharacter) -> ItemSet
    {
        switch self
        {
        case let .regex         (regex):
            return regex.move(over: c)

        case .epsilon:
            return ItemSet()

        case let .union         (l, r):
            return l.move(over: c).union(r.move(over: c))

        case let .concatenation (l, r):
            return Set(l.move(over: c).map
            { regex in
                Regex(
                    basicRegex: .concatenation(regex, r),
                    repetitionOperator: nil)
            })

        case let .characterSet  (characterSet):
            if c == characterSet { return ItemSet([Regex()]) }
            else                 { return ItemSet() }
        }
    }
}
