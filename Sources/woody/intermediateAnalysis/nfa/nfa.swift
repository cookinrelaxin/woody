import Foundation

struct NFA
{
    typealias State           = Int
    typealias CharacterSet    = AST.CharacterSet
    typealias Regex           = AST.Regex
    enum Character            { case ε, range(ElementaryRange) }
    typealias TransitionTable = [ Domain : Range ]
    struct Domain: Hashable
    {
        let state: State
        let character: Character

        init(_ state: State, _ character: Character)
        {
            self.state = state
            self.character = character
        }
    }
    typealias Range = Set<State>

    private let start       : State
    private let end         : State
    private let transitions : TransitionTable

    private let rangeLookup : ElementaryRangeQueryable

    subscript(_ state: State, _ scalar: Scalar) -> Range?
    {
        guard let elementaryRange = rangeLookup[scalar] else { return nil }
        return transitions[Domain(state, elementaryRange)]
    }

    init(_ start: State, _ end: State, _ transitions: TransitionTable)
    {
        self.start       = start
        self.end         = end
        self.transitions = transitions
    }

    init(from regex: Regex)
    {
        let rangeLookup = SBERT(from: regex)
        let start = 0

        self.init(regex, start, rangeLookup)
    }

    private init(from regex: Regex,
                 _ start: State,
                 _ rangeLookup: ElementaryRangeQueryable)
    {
        let nfa: NFA
        switch regex
        {
        case .ε:
            nfa = NFA.fromE(start)

        case .characterSet(let characterSet):
            nfa = NFA.fromCharacterSet(characterSet, start, rangeLookup)

        case .oneOrMore(let r):
            nfa = NFA.fromOneOrMore(r, start, rangeLookup)

        case .union(let r1, let r2):
            nfa = NFA.fromUnion(r1, r2, start, rangeLookup)

        case .concatenation(let r1, let r2):
            nfa = NFA.fromConcatenation(r1, r2, start, rangeLookup)
        }

        return nfa
    }

    static func fromE(_ start: State) -> NFA
    {
        let end = start + 1
        let transitions: TransitionTable =
        [ Domain(startState, .ε) : [ endState ]]

        return NFA(start, end, transitions)
    }

    static func fromCharacterSet(_ characterSet: CharacterSet,
                                 _ start: State,
                                 _ rangeLookup: ElementaryRangeQueryable) -> NFA
    {
        let end = start + 1

        var transitions = TransitionTable()

        for e in rangeLookup[characterSet]
        { transitions[Domain(start, .range(e))] = [ end ] }

        return NFA(start, end, transitions)
    }

    static func fromUnion(_ r1: Regex,
                          _ r2: Regex,
                          _ start: State,
                          _ rangeLookup: ElementaryRangeQueryable) -> NFA
    {
        let a1 = NFA.from(regex: r1, start + 1, rangeLookup)
        let a2 = NFA.from(regex: r2, a1.end + 1, rangeLookup)

        let end = a2.end + 1

        let merged = a1.transitions.merging(a2) { fatalError() }

        let transitions: TransitionTable
        = [ Domain(start, .ε) : [ a1.start, a2.start ],
            Domain(a1.end, ε) : [ end ],
            Domain(a2.end, ε) : [ end ]
          ].merging(merged) { fatalError() }

        return NFA(start, end, transitions)
    }

    static func fromConcatenation(_ r1: Regex,
                                  _ r2: Regex,
                                  _ start: State,
                                  _ rangeLookup: ElementaryRangeQueryable)
    -> NFA
    {
        let a1 = NFA.from(regex: r1, start, rangeLookup)
        let a2 = NFA.from(regex: r2, a1.end, rangeLookup)

        let end = a2.end

        let transitions = a1.transitions.merging(a2) { fatalError() }

        return NFA(start, end, transitions)
    }

    static func fromOneOrMore(_ r: Regex,
                              _ start: State,
                              _ rangeLookup: ElementaryRangeQueryable) -> NFA
    {
        let a = NFA.from(regex: r, start+1, rangeLookup)

        let end = a.end + 1

        let transitions: TransitionTable =
        [
            Domain(start, .ε) : [ a.start, end ],
            Domain(a.end, .ε) : [ a.start, end ],
        ].merging(a) { fatalError() }

        return NFA(start, end, transitions)
    }
}

extension NFA
{
    func εClosure(_ s: State) -> Set<State> { return εClosure([ s ]) }

    func εClosure(_ set: Set<State>) -> Set<State>
    {
        var _εClosure = Set<State>()
        var q         = set

        while let start = q.pop()
        {
            let newStates = transitions[Domain(start, ε)].subtracting(_εClosure)
            _εClosure.formUnion(newStates)
            q.formUnion(newStates)
        }
    }

    func move(_ set: Set<State>, scalar: Scalar) -> Set<State>
    { return set.unionMap { self[$0, scalar] } }
}
