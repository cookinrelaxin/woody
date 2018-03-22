import Foundation

extension Set
{
    mutating func pop() -> Element?
    {
        if isEmpty { return nil }
        return removeFirst()
    }
}

final class LexerGenerator
{
    typealias Code            = String
    typealias ScalarString    = String.UnicodeScalarView
    typealias Rule            = AST.Rule
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias MacroCharacter  = CharacterSet
    typealias ItemSet         = Set<Regex>
    typealias TransitionTable = [TransitionPair : ItemSet]

    let ast: AbstractSyntaxTree

    init(ast: AbstractSyntaxTree)
    { self.ast = ast }

    lazy var initialState: ItemSet =
    { ast.rules.reduce(ItemSet()) { $0.union(ItemSet([$1.regex])) } }()

    lazy var mentionedCharacterSets: Set<MacroCharacter> =
    {
        initialState.reduce(Set<MacroCharacter>())
        { $0.union(_mentionedCharacterSets(in: $1)) }
    }()

    lazy var transitionTable: TransitionTable =
    {
        let cs = mentionedCharacterSets
        var transitionFunction = TransitionTable()
        var q = Set<TransitionPair>(cs.map { TransitionPair(initialState, $0) })

        while let t = q.pop()
        {
            let endState          = _endState(for: t)
            transitionFunction[t] = endState

            for c in cs
            {
                let x = TransitionPair(endState, c)
                if transitionFunction[x] == nil { q.insert(x) }
            }
        }

        return transitionFunction
    }()

    struct StrippedTransitionPair: Hashable, SEXPPrintable
    {   let state: Int; let c: MacroCharacter
        init(_ state: Int, _ c: MacroCharacter) {self.state = state; self.c = c}

        func sexp(_ indentation: Swift.String) -> Swift.String
        { return indentation+"(\(state) \(c))" }

    }

    lazy var strippedTransitionTable: [ StrippedTransitionPair : Int ] =
    {
        var t      = [ StrippedTransitionPair : Int ]()
        var lookup = [ ItemSet : Int ]()
        var c      = 0

        for (k,v) in transitionTable
        {
            let kInt: Int
            let vInt: Int

            if let i = lookup[k.itemSet] { kInt = i }
            else { lookup[k.itemSet] = c; kInt = c; c += 1 }

            if let i = lookup[v] { vInt = i }
            else { lookup[v] = c; vInt = c; c += 1 }

            t[StrippedTransitionPair(kInt, k.macroCharacter)] = vInt
        }

        return t
    }()

    func _endState(for t: TransitionPair) -> ItemSet
    {
        let start = t.itemSet
        let c     = t.macroCharacter

        return start.reduce(ItemSet()) { $0.union($1.move(over: c)) }
    }

    private func _mentionedCharacterSets(in regex: Regex) -> Set<CharacterSet>
    {
        switch regex.basicRegex
        {
        case let .regex(r): return _mentionedCharacterSets(in: r)

        case .epsilon: return []

        case let .union(r1, r2):
            return _mentionedCharacterSets(in: r1)
            .union(_mentionedCharacterSets(in: r2))

        case let .concatenation(r1, r2):
            return _mentionedCharacterSets(in: r1)
            .union(_mentionedCharacterSets(in: r2))

        case let .characterSet(c): return [c]
        }
    }
}

extension LexerGenerator
{
    struct TransitionPair: Equatable, Hashable
    {
        let itemSet: ItemSet
        let macroCharacter: MacroCharacter

        init(_ itemSet: ItemSet, _ macroCharacter: MacroCharacter)
        {
            self.itemSet        = itemSet
            self.macroCharacter = macroCharacter
        }
    }
}

fileprivate extension AST.Regex
{
    typealias Rule            = AST.Rule
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias MacroCharacter  = CharacterSet
    typealias ItemSet         = Set<Regex>

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
    typealias Rule            = AST.Rule
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias MacroCharacter  = CharacterSet
    typealias ItemSet         = Set<Regex>

    func move(over c: MacroCharacter) -> ItemSet
    {
        switch self
        {
        case let .regex(regex): return regex.move(over: c)

        case .epsilon: return ItemSet()

        case let .union(l, r): return l.move(over: c).union(r.move(over: c))

        case let .concatenation(l, r):
            return Set(l.move(over: c).map
            { regex in
                Regex(
                    basicRegex: .concatenation(regex, r),
                    repetitionOperator: nil)
            })

        case let .characterSet(characterSet):
            if c == characterSet { return ItemSet([Regex()]) }
            else                 { return ItemSet() }
        }
    }
}
