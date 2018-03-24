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
    {
        return ast.rules.reduce(Set<CharacterSet>())
        { $0.union(mentionedCharacterSets(in: $1)) }
    }()

    lazy var elementaryRanges: Set<ElementaryRange> =
    {
        typealias EndPoints = [Scalar]

        let endPoints = allMentionedCharacterSets.reduce(Set<Scalar>())
        {
            $1.positiveSet.union($1.negativeSet)
              .reduce(Set<Scalar>())
            { $0.union([$1.lowerBound, $1.upperBound]) }.union($0)
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

    func elementaryRanges(in itemSet: ItemSet) -> Set<ElementaryRange>
    {
        return itemSet.reduce([]) { $0.union(elementaryRanges(in: $1)) }
    }

    func elementaryRanges(in tokenDefinition: TokenDefinition)
    -> Set<ElementaryRange>
    { return _elementaryRanges(in: tokenDefinition.regex) }

    private func _elementaryRanges(in regex: Regex) -> Set<ElementaryRange>
    { return _elementaryRanges(in: regex.basicRegex) }

    private func _elementaryRanges(in basicRegex: BasicRegex)
    -> Set<ElementaryRange>
    {
        switch basicRegex
        {
        case let .regex(r): return _elementaryRanges(in: r)

        case .epsilon: return []

        case let .union(r, s):
            return _elementaryRanges(in: r).union(_elementaryRanges(in: s))

        case let .concatenation(r, s):
            return _elementaryRanges(in: r).union(_elementaryRanges(in: s))

        case let .characterSet(characterSet):
            return characterSet.positiveSet.reduce([])
            { $0.union(sbert.ranges(for: $1)) }
        }
    }

    lazy var sbert: SBERT = { SBERT(elementaryRanges)! }()

    lazy var transitionTable: TransitionTable =
    {
        var f = TransitionTable()
        var q: Set<ItemSet> = [initialState]

        while let itemSet = q.pop()
        {
            let erDict = elementaryRangeDictionary(for: itemSet)

            for e in erDict.keys
            {
                guard let itemSet = erDict[e],
                case let p = TransitionPair(itemSet, e),
                f[p] == nil
                else { continue }

                let endState = _endState(for: p)

                q.insert(endState)
                f[p] = endState
            }
        }

        return f
    }()

    typealias ERDict = [ ElementaryRange : ItemSet ]
    func elementaryRangeDictionary(for itemSet: ItemSet) -> ERDict
    {
        return itemSet.reduce(ERDict())
        { dict, item in
            var _dict = dict

            for e in elementaryRanges(in: item)
            { _dict[e, default: ItemSet()].insert(item) }

            return _dict
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

    lazy var strippedTransitionTable: StrippedTransitionTable =
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

        return t
    }()

    func _endState(for t: TransitionPair) -> ItemSet
    { return t.itemSet.reduce(ItemSet()) { $0.union($1.move(over: t.range)) } }

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

    enum ElementaryRange: Equatable, Hashable, Comparable, SEXPPrintable
    {
        case scalar          (Scalar)
        case discreteSegment (Scalar, Scalar)

        func sexp(_ indentation: Swift.String) -> Swift.String
        {
            let i = indentation
            let fmt = "U+%X"

            switch self
            {
            case let .scalar(s):
                return "\(i)\(String(format: fmt, s.value))"

            case let .discreteSegment(s, t):
                let f1 = String(format: fmt, s.value)
                let f2 = String(format: fmt, t.value)

                return "\(i)(\(f1) \(f2))"
            }
        }

        static func < (_ l: ElementaryRange, _ r: ElementaryRange) -> Bool
        {
            switch (l, r)
            {
            case let (.scalar(s1), .scalar(s2)):
                return s1 < s2
            case let (.scalar(s1), .discreteSegment(s2, _)):
                return s1 <= s2
            case let (.discreteSegment(_, s1), .scalar(s2)):
                return s1 <= s2
            case let (.discreteSegment(s1, _), .discreteSegment(s2, _)):
                return s1 < s2
            }
        }

        static func < (_ l: ElementaryRange, _ r: ScalarRange) -> Bool
        {
            switch l
            {
                case let .scalar(s)             : return s < r.lowerBound
                case let .discreteSegment(_, s) : return s <= r.lowerBound
            }
        }

        static func < (_ l: ScalarRange, _ r: ElementaryRange) -> Bool
        {
            switch r
            {
                case let .scalar(s)             : return l.upperBound < s
                case let .discreteSegment(s, _) : return l.upperBound <= s
            }
        }

        func contains(_ scalar: Scalar) -> Bool
        {
            switch self
            {
                case let .scalar(s)            : return scalar == s
                case let .discreteSegment(s,t) : return s < scalar && scalar < t
            }
        }
    }

    typealias SBERT = SelfBalancingElementaryRangeTree
    final class SelfBalancingElementaryRangeTree: SEXPPrintable
    {
        enum Balance   { case hardLeft, left, even, right, hardRight }
        enum Insertion { case left, none, right }

        let value : ElementaryRange
        let left  : SBERT?
        let right : SBERT?

        init(_ value: ElementaryRange)
        {
            self.value = value
            self.left  = nil
            self.right = nil
        }

        init(_ sbert: SBERT)
        {
            self.value = sbert.value
            self.left  = sbert.left
            self.right = sbert.right
        }

        convenience init?(_ values: Set<ElementaryRange>)
        {
            guard let first = values.first else { return nil }
            let rest = values.dropFirst()

            if rest.isEmpty { self.init(first) }
            else            { self.init(SBERT(Set(values.dropFirst()))!
                                        .inserting(first)) }

        }

        init(_ value: ElementaryRange, _ left: SBERT?, _ right: SBERT?)
        {
            self.value = value
            self.left  = left
            self.right = right
        }

        func inserting(_ range: ElementaryRange) -> SBERT
        { return _inserting(range).0 }

        func _inserting(_ range: ElementaryRange) -> (SBERT, Insertion)
        {
            if range < value      { return (_insertingLeft(range), .left) }
            else if range > value { return (_insertingRight(range), .right) }
            else                  { return (self, .none) }
        }

        lazy var height: Int =
        { return max(left?.height ?? 0, right?.height ?? 0) + 1 }()

        lazy var balance: Balance =
        {
            let bf: Int = ((right?.height ?? 0) - (left?.height ?? 0))

            switch bf
            {
                case ...(-2)  : return .hardLeft
                case    -1    : return .left
                case     0    : return .even
                case     1    : return .right
                case     2... : return .hardRight
                default       : fatalError()
            }
        }()

        lazy var isBalanced: Bool =
        { balance == .left || balance == .even || balance == .right }()

        lazy var bstInvariantHolds: Bool =
        {
            switch (left, right)
            {
            case (nil, nil): return true

            case let (l?, nil) where l.values.max()! < value &&
                                     l.bstInvariantHolds: return true

            case let (nil, r?) where value < r.values.min()! &&
                                     r.bstInvariantHolds: return true

            case let (l?, r?) where l.values.max()! < value &&
                                    value < r.values.min()! &&
                                    l.bstInvariantHolds &&
                                    r.bstInvariantHolds: return true

            default: return false
            }
        }()

        lazy var isAVL: Bool = { isBalanced && bstInvariantHolds }()

        lazy var count: Int =
        { (left?.count ?? 0) + (right?.count ?? 0) + 1 }()

        lazy var values: Set<ElementaryRange> =
        {
            (left?.values ?? Set<ElementaryRange>())
            .union(right?.values ?? Set<ElementaryRange>())
            .union([value])
        }()

        private func _insertingLeft(_ range: ElementaryRange) -> SBERT
        {
            guard let left = left else
            { return SBERT(value, SBERT(range), right) }

            let (newLeft, insertion) = left._inserting(range)

            if balance == .hardLeft
            {
                if insertion == .left
                { return SBERT(value, newLeft, right)
                         .rotatingRight() }

                if insertion == .right
                { return SBERT(value, newLeft.rotatingLeft(), right)
                         .rotatingRight() }
            }

            return SBERT(value, newLeft, right)
        }

        private func _insertingRight(_ range: ElementaryRange) -> SBERT
        {
            guard let right = right else
            { return SBERT(value, left, SBERT(range)) }

            let (newRight, insertion) = right._inserting(range)

            if balance == .hardRight
            {
                if insertion == .right
                { return SBERT(value, left, newRight).rotatingLeft() }

                if insertion == .left
                { return SBERT(value, left, newRight.rotatingRight())
                         .rotatingLeft() }
            }

            return SBERT(value, left, newRight)
        }

        private func rotatingLeft() -> SBERT
        {
            guard let right = right else { return self }

            return SBERT(right.value,
                         SBERT(value,
                               left,
                               right.left),
                         right.right)
        }

        private func rotatingRight() -> SBERT
        {
            guard let left = left else { return self }

            return SBERT(left.value,
                         left.left,
                         SBERT(value,
                               left.right,
                               right))
        }

        func range(for s: Scalar) -> ElementaryRange?
        { return _range(for: .scalar(s)) }

        private func _range(for r: ElementaryRange) -> ElementaryRange?
        {
            /*print("find \(r) in \(self)")*/
            if r < value      { return left?._range(for: r) }
            else if r > value { return right?._range(for: r) }
            else              { return value }
        }

        func ranges(for s: ScalarRange) -> Set<ElementaryRange>
        {
            if s < value { return left?.ranges(for: s) ?? [] }
            if value < s { return right?.ranges(for: s) ?? [] }

            return (s.contains(value) ? Set([value]) : Set([]))
                   .union(left?.ranges(for: s) ?? [])
                   .union(right?.ranges(for: s) ?? [])
        }

        func sexp(_ indentation: String) -> String
        {
            let i = indentation+standardIndentation
            let _left  = left != nil ? left!.sexp(i) : "\(i)nil"
            let _right = right != nil ? right!.sexp(i) : "\(i)nil"

            return indentation+"""
            (\(value)
            \(_left)
            \(_right))
            """
        }
    }
}
fileprivate extension AST.TokenDefinition
{
    typealias TokenDefinition = AST.TokenDefinition
    typealias ElementaryRange = LexerGenerator.ElementaryRange
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
    typealias ElementaryRange = LexerGenerator.ElementaryRange

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
    typealias ElementaryRange = LexerGenerator.ElementaryRange

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
