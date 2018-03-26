import Foundation
import Dispatch

final class LexerGenerator
{
    typealias Code            = String
    typealias ScalarString    = String.UnicodeScalarView
    typealias TokenDefinition = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias MacroCharacter  = CharacterSet
    typealias ItemSet         = Set<TokenDefinition>
    typealias TransitionTable = [TransitionPair : ItemSet]

    let ast: AbstractSyntaxTree

    init(astFactory: ASTFactory) { self.ast = astFactory.abstractSyntaxTree }

    lazy var initialState: ItemSet = { Set(ast.rules) }()

    lazy var allMentionedCharacterSets: Set<CharacterSet> =
    { return ast.rules.unionMap { mentionedCharacterSets(in: $0) } }()

    lazy var elementaryRanges: Set<ElementaryRange> =
    {
        typealias EndPoints = [Scalar]

        let endPoints = allMentionedCharacterSets.unionMap
        {
            $0.positiveSet.union($0.negativeSet)
            .unionMap { [ $0.lowerBound, $0.upperBound ] }
        }.sorted()

        var _elementaryRanges = Set<ElementaryRange>()
        for (i, p) in endPoints.enumerated()
        {
            /*print("(i, p): \(i, p)")*/

            _elementaryRanges.insert(.scalar(p))
            if i+1 < endPoints.count,
            case let q = endPoints[i+1],
            (p.value)+1 < q.value
            { _elementaryRanges.insert(.discreteSegment(p, q)) }
        }

        return _elementaryRanges
    }()

    func elementaryRanges(in itemSet: ItemSet,
                          immediateOnly: Bool = true) -> Set<ElementaryRange>
    {
        return itemSet.unionMap
        { elementaryRanges(in: $0, immediateOnly: immediateOnly) }
    }

    func elementaryRanges(in tokenDefinition: TokenDefinition,
                          immediateOnly: Bool = true)
    -> Set<ElementaryRange>
    { return _elementaryRanges(in: tokenDefinition.regex,
                               immediateOnly: immediateOnly) }

    private func _elementaryRanges(in regex: Regex,
                                   immediateOnly: Bool = true)
    -> Set<ElementaryRange>
    { return _elementaryRanges(in: regex.basicRegex,
                               immediateOnly: immediateOnly) }

    private func _elementaryRanges(in basicRegex: BasicRegex,
                                   immediateOnly: Bool = true)
    -> Set<ElementaryRange>
    {
        switch basicRegex
        {
        case let .regex(r): return _elementaryRanges(in: r)

        case .epsilon: return []

        case let .union(r, s):
            return _elementaryRanges(in: r).union(_elementaryRanges(in: s))

        case let .concatenation(r, s):
            if immediateOnly { return _elementaryRanges(in: r) }
            return _elementaryRanges(in: r).union(_elementaryRanges(in: s))

        case let .characterSet(characterSet):
            return characterSet.positiveSet.unionMap { sbert[$0] }
        }
    }

    typealias ERDict = [ ElementaryRange : ItemSet ]
    func relevantSubstateLookup(for itemSet: ItemSet,
                                immediateOnly: Bool = true) -> ERDict
    {
        var dict = ERDict()

        for item in itemSet
        {
            for e in elementaryRanges(in: item, immediateOnly: immediateOnly)
            { dict[e, default: ItemSet()].insert(item) }
        }

        return dict
    }

    lazy var sbert: SBERT = { SBERT(elementaryRanges)! }()

    lazy var transitionTable: TransitionTable =
    {
        var f                = TransitionTable()
        var q                = Set([initialState])
        var discoveredStates = Set<ItemSet>()

        let dq = DispatchQueue(label: "transitions")
        let dg = DispatchGroup()

        while q.isNotEmpty
        {
            var newlyDiscoveredStates = Set<ItemSet>()

            while let state = q.pop()
            {
                let lookup = self.relevantSubstateLookup(for: state)

                for (e, subState) in lookup
                {
                    dq.async(group: dg)
                    {
                        let endState
                        = self._endState(for: TransitionPair(subState, e))

                        newlyDiscoveredStates.insert(endState)
                        f[TransitionPair(state, e)] = endState
                    }
                }
            }

            dg.wait()

            q = newlyDiscoveredStates.subtracting(discoveredStates)
            discoveredStates.formUnion(newlyDiscoveredStates)
        }

        return f
    }()

    private func first(in tokenDefinitions: ItemSet) -> String?
    {
        let candidates: ItemSet = tokenDefinitions
                                  .filter{ $0.regex == Regex() }

        return candidates.reduce((tokenClass: nil, order: Int.max))
               { $1.order < $0.order ? ($1.tokenClass, $1.order) : $0 }
               .tokenClass
    }

    lazy var strippedTransitionTable: StrippedTransitionTable =
    {
        var t      = [ StrippedTransitionPair : LabeledState ]()
        var states = [ ItemSet : LabeledState ]()
        let c =
        { () -> (() -> Int) in
            var _c = 0
            return { () -> Int in
                _c += 1
                return _c - 1
            }
        }()

        for (k,v) in transitionTable
        {
            let (startItems, endItems) = (k.itemSet, v)

            let startStateId: Int
            let endState: LabeledState

            if let state = states[startItems] { startStateId = state.id }
            else
            {
                startStateId = c()
                states[startItems] = LabeledState(startStateId,
                                                  first(in: startItems))
            }

            if let state = states[endItems] { endState = state }
            else
            {
                endState = LabeledState(c(), first(in: endItems))
                states[endItems] = endState
            }

            t[StrippedTransitionPair(startStateId, k.range)] = endState
        }

        let _initialState = states[initialState]!

        return StrippedTransitionTable(f: t, start: _initialState)
    }()

    func mentionedCharacterSets(in tokenDefinition: TokenDefinition)
    -> Set<CharacterSet>
    { return _mentionedCharacterSets(in: tokenDefinition.regex) }

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

    enum ExecutionMode { case development, release }
    func analyze(_ source: ScalarString,
                 mode: ExecutionMode = .release) -> [(String, String?)]
    {
        switch mode
        {
            case .development : return _analyze_development(source)
            case .release     : return _analyze_development(source)
        }
    }

    private func _analyze_development(_ source: ScalarString)
    -> [(String, String?)]
    {
        typealias STP = StrippedTransitionPair

        var dot          = source.startIndex

        func nextToken() -> (String, String?)
        {
            let startOfToken               = dot
            var endOfToken : String.Index? = nil
            var tokenClass : String?       = nil
            var state      : ItemSet       = initialState

            while state.isNotEmpty
            {
                let e = sbert[source[dot]]
                state =
                    e == nil
                    ? ItemSet()
                    : _endState(for: TransitionPair(state, e!))

                if let tc = first(in: state)
                {
                    tokenClass = tc
                    endOfToken = dot
                }

                dot = source.index(after: dot)
            }

            var representation = ""

            if let endOfToken = endOfToken
            {
                representation = String(source[startOfToken...endOfToken])
                dot            = source.index(after: endOfToken)
            }
            else { representation = String(source[startOfToken..<dot]) }

            let token = (representation, tokenClass)

            return token
        }

        var tokens = [(String, String?)]()

        while dot != source.endIndex { tokens.append(nextToken()) }

        return tokens
    }

    private func _analyze_release(_ source: ScalarString) -> [(String, String?)]
    {
        typealias STP = StrippedTransitionPair

        var dot          = source.startIndex
        let f            = strippedTransitionTable.f
        let initialState = strippedTransitionTable.start

        func nextToken() -> (String, String?)
        {
            let startOfToken               = dot
            var endOfToken : String.Index? = nil
            var tokenClass : String?       = nil
            var state      : LabeledState? = initialState

            while state != nil
            {
                let e = sbert[source[dot]]
                state = e == nil ? nil : f[STP(state!.id, e!)]

                if let tc = state?.tokenClass
                {
                    tokenClass = tc
                    endOfToken = dot
                }

                dot = source.index(after: dot)
            }

            var representation = ""

            if let endOfToken = endOfToken
            {
                representation = String(source[startOfToken...endOfToken])
                dot            = source.index(after: endOfToken)
            }
            else { representation = String(source[startOfToken..<dot]) }

            let token = (representation, tokenClass)

            return token
        }

        var tokens = [(String, String?)]()

        while dot != source.endIndex { tokens.append(nextToken()) }

        return tokens
    }

    func _endState(for t: TransitionPair) -> ItemSet
    { return t.itemSet.unionMap { $0.move(over: t.range) } }
}

extension LexerGenerator
{
    struct TransitionPair: Equatable, Hashable
    {
        let itemSet: ItemSet
        let range: ElementaryRange

        init(_ itemSet: ItemSet, _ range: ElementaryRange)
        {
            self.itemSet = itemSet
            self.range   = range
        }
    }

    struct StrippedTransitionPair: Hashable, SEXPPrintable
    {   let state: Int; let range: ElementaryRange
        init(_ state: Int, _ r: ElementaryRange)
        {self.state = state; self.range = r}

        func sexp(_ indentation: String) -> String
        { return indentation+"(\(state) \(range))" }
    }

    struct LabeledState: SEXPPrintable
    {   let id: Int
        let tokenClass: String?

        init(_ id: Int, _ t: String?)
        {self.id = id; self.tokenClass = t}

        func sexp(_ indentation: String) -> Swift.String
        { return indentation+"(\(id) \(tokenClass ?? "nil"))" }
    }

    struct StrippedTransitionTable
    {
        let f: [ StrippedTransitionPair : LabeledState ]
        let start: LabeledState
    }
}

fileprivate extension AST.TokenDefinition
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias ItemSet         = Set<TokenDefinition>

    func move(over r: ElementaryRange) -> ItemSet
    {
        return regex.move(over: r)
               .filter { $0.didConsumeInput }
               .unionMap { TokenDefinition(tokenClass, order, $0.regex) }
    }
}

fileprivate extension AST.Regex
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet

    struct Move: Hashable
    {
        let regex: Regex
        let didConsumeInput: Bool

        init(_ regex: Regex, _ didConsumeInput: Bool)
        {
            self.regex = regex
            self.didConsumeInput = didConsumeInput
        }
    }

    var once: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: nil) }

    var zeroOrOne: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .zeroOrOne) }

    var oneOrMore: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .oneOrMore) }

    var zeroOrMore: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .zeroOrMore) }

    static func +(_ l: Regex, _ r: Regex) -> Regex
    {
        switch (l.basicRegex, r.basicRegex)
        {
            case (.epsilon, .epsilon) : return l
            case (.epsilon, _)        : return r
            case (_, .epsilon)        : return l
            default:
                return Regex(basicRegex: .concatenation(l, r),
                             repetitionOperator: nil)
        }
    }

    func move(over r: ElementaryRange) -> Set<Move>
    {
        switch repetitionOperator
        {
            case nil          : return basicRegex.move(over: r)

            case .zeroOrOne?  : return Set([Move(ε, false)])
                                       .union(once.move(over: r))

            case .zeroOrMore? : return Set([Move(ε, false)])
                                       .union(oneOrMore.move(over: r))

            case .oneOrMore?  : return once.move(over: r)
                                       .union((once+oneOrMore).move(over: r))
        }
    }
}

fileprivate extension AST.BasicRegex
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias Move            = AST.Regex.Move

    func move(over r: ElementaryRange) -> Set<Move>
    {
        switch self
        {
        case let .regex(regex): return regex.move(over: r)

        case .epsilon: return [ Move(ε, false) ]

        case let .union(left, right): return left.move(over: r)
                                             .union(right.move(over: r))

        case let .concatenation(left, right):
            return left.move(over: r)
                       .unionMap
                        { (m) -> Set<Move> in
                            if !m.didConsumeInput { return right.move(over: r) }
                            if right.repetitionOperator == .zeroOrOne ||
                               right.repetitionOperator == .zeroOrMore
                            {
                                return right.move(over: r).unionMap
                                { Move(m.regex + $0.regex, true) }
                            }
                            return Set([Move(m.regex + right, true)])
                        }.union()

        case let .characterSet(characterSet):
            return characterSet.contains(r) ? [ Move(ε, true) ] : []
        }
    }
}
