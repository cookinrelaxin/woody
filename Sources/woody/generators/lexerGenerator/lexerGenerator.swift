import Foundation
import Dispatch

protocol UnionMappable: Sequence
{
    associatedtype Element

    func unionMap<T>(_ closure: (Element) -> T) -> Set<T>
    func unionMap<T>(_ closure: (Element) -> Set<T>) -> Set<T>
}

extension UnionMappable
{
    func unionMap<T>(_ closure: (Element) -> T) -> Set<T>
    { return reduce(Set<T>()) { set, e in set.union([closure(e)]) } }

    func unionMap<T>(_ closure: (Element) -> Set<T>) -> Set<T>
    { return reduce(Set<T>()) { set, e in set.union(closure(e)) } }
}

extension Set
{
    mutating func pop() -> Element?
    {
        if isEmpty { return nil }
        return removeFirst()
    }
}

extension Set   : UnionMappable {}
extension Array : UnionMappable {}

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
                          immediateOnly: Bool = false) -> Set<ElementaryRange>
    {
        return itemSet.unionMap
        { elementaryRanges(in: $0, immediateOnly: immediateOnly) }
    }

    func elementaryRanges(in tokenDefinition: TokenDefinition,
                          immediateOnly: Bool = false)
    -> Set<ElementaryRange>
    { return _elementaryRanges(in: tokenDefinition.regex,
                               immediateOnly: immediateOnly) }

    private func _elementaryRanges(in regex: Regex,
                                   immediateOnly: Bool = false)
    -> Set<ElementaryRange>
    { return _elementaryRanges(in: regex.basicRegex,
                               immediateOnly: immediateOnly) }

    private func _elementaryRanges(in basicRegex: BasicRegex,
                                   immediateOnly: Bool = false)
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
                                immediateOnly: Bool = false) -> ERDict
    {
        return itemSet.reduce(ERDict())
        { dict, item in
            var _dict = dict

            for e in elementaryRanges(in: item, immediateOnly: immediateOnly)
            { _dict[e, default: ItemSet()].insert(item) }

            return _dict
        }
    }

    lazy var sbert: SBERT = { SBERT(elementaryRanges)! }()

    lazy var transitionTable: TransitionTable =
    {
        var f = TransitionTable()
        var q = Set([initialState])

        while let state = q.pop()
        {
            let lookup = self.relevantSubstateLookup(for: state,
                                                     immediateOnly: true)
            for e in lookup.keys
            {
                let p1 = TransitionPair(state, e)

                guard f[p1] == nil else { continue }

                let p2 = TransitionPair(lookup[e]!, e)
                let endState = self._endState(for: p2)

                q.insert(endState)
                f[p1] = endState
            }
        }

        return f
    }()

    lazy var strippedTransitionTable: (initialState: LabeledState,
                                       table: StrippedTransitionTable) =
    {
        var t      = StrippedTransitionTable()
        var states = [ ItemSet : LabeledState ]()
        var c      = 0

        func first(in tokenDefinitions: ItemSet) -> String?
        {
            let candidates: ItemSet = tokenDefinitions
                                      .filter{ $0.regex == Regex() }

            return candidates.reduce((tokenClass: nil, order: Int.max))
                   { $1.order < $0.order ? ($1.tokenClass, $1.order) : $0 }
                   .tokenClass
        }

        for (k,v) in transitionTable
        {
            let (startItems, endItems) = (k.itemSet, v)

            let startStateId: Int
            let endState: LabeledState

            if let state = states[startItems] { startStateId = state.id }
            else
            {
                startStateId = c
                states[startItems] = LabeledState(startStateId,
                                                  first(in: startItems))
                c += 1
            }

            if let state = states[endItems] { endState = state }
            else
            {
                endState = LabeledState(c, first(in: endItems))
                states[endItems] = endState
                c += 1
            }

            t[StrippedTransitionPair(startStateId, k.range)] = endState
        }

        let _initialState = states[initialState]!
        return (_initialState, t)
    }()

    func _endState(for t: TransitionPair) -> ItemSet
    { return t.itemSet.unionMap { $0.move(over: t.range) } }

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

    func analyze(_ source: ScalarString) -> [(String, String?)]
    {
        var dot          = source.startIndex
        let f            = strippedTransitionTable.table
        let initialState = strippedTransitionTable.initialState

        func nextToken() -> (String, String?)
        {
            let startOfToken = dot
            var tokenClass: String? = nil
            var state: LabeledState = initialState

            while dot != source.endIndex
            {
                let c = source[dot]

                guard let e = sbert[c],
                let endState = f[StrippedTransitionPair(state.id, e)]
                else { break }

                state = endState
                tokenClass = endState.tokenClass

                dot = source.index(after: dot)
            }

            return (String(source[startOfToken..<dot]), tokenClass)
        }

        var tokens = [(String, String?)]()

        while dot != source.endIndex { tokens.append(nextToken()) }

        return tokens
    }
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

    typealias StrippedTransitionTable
    = [ StrippedTransitionPair : LabeledState ]
}

fileprivate extension AST.TokenDefinition
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias ItemSet         = Set<TokenDefinition>

    func move(over r: ElementaryRange) -> ItemSet
    {
        return Set(regex.move(over: r).map
        { TokenDefinition(tokenClass, order, $0)} )
    }
}

fileprivate extension AST.Regex
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet

    var once: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: nil) }

    var zeroOrOne: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .zeroOrOne) }

    var oneOrMore: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .oneOrMore) }

    var zeroOrMore: Regex
    { return Regex(basicRegex: basicRegex, repetitionOperator: .zeroOrMore) }

    var ε: Regex { return Regex() }

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

    func move(over r: ElementaryRange) -> Set<Regex>
    {
        switch repetitionOperator
        {
            case nil          : return basicRegex.move(over: r)
            case .zeroOrOne?  : return Set([ε]).union(once.move(over: r))
            case .zeroOrMore? : return Set([ε]).union(oneOrMore.move(over: r))
            case .oneOrMore?  : return (once + zeroOrMore).move(over: r)
        }
    }
}

fileprivate extension AST.BasicRegex
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet

    func move(over r: ElementaryRange) -> Set<Regex>
    {
        switch self
        {
        case let .regex(regex): return regex.move(over: r)

        case .epsilon: return Set()

        case let .union(left, right):
            return left.move(over: r).union(right.move(over: r))

        case let .concatenation(left, right):
            switch left.basicRegex
            {
                case .epsilon : return right.move(over: r)
                default       : return Set(left.move(over: r).map{ $0 + right })
            }

        case let .characterSet(characterSet):
            return characterSet.contains(r) ? [Regex()] : Set()
        }
    }
}
