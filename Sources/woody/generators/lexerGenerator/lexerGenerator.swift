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
    typealias TokenDefinition            = AST.TokenDefinition
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

    lazy var elementaryRanges: Set<ElementaryRange> =
    {
        typealias EndPoints = [Scalar]

        let endPoints: EndPoints = mentionedCharacterSets.reduce(Set<Scalar>())
        {
            $1.positiveSet
              .union($1.negativeSet)
              .reduce(Set<Scalar>())
            { $0.union([$1.lowerBound, $1.upperBound]) }.union($0)
        }.sorted()

        /*print(endPoints)*/

        var _elementaryRanges = Set<ElementaryRange>()
        for (i, p) in endPoints.enumerated()
        {
            _elementaryRanges.insert(.scalar(p))
            if i+1 < endPoints.count,
            case let q = endPoints[i+1],
            (p.value)+1 < q.value
            { _elementaryRanges.insert(.discreteSegment(p, q)) }
        }

        return _elementaryRanges
    }()

    lazy var sbert: SBERT = { SBERT(elementaryRanges)! }()

    lazy var transitionTable: TransitionTable =
    {
        let rs = elementaryRanges
        var transitionFunction = TransitionTable()
        var q = Set<TransitionPair>(rs.map { TransitionPair(initialState, $0) })

        while let t = q.pop()
        {
            let endState          = _endState(for: t)
            transitionFunction[t] = endState

            for r in rs
            {
                let x = TransitionPair(endState, r)
                if transitionFunction[x] == nil { q.insert(x) }
            }
        }

        return transitionFunction
    }()

    struct StrippedTransitionPair: Hashable, SEXPPrintable
    {   let state: Int; let range: ElementaryRange
        init(_ state: Int, _ r: ElementaryRange)
        {self.state = state; self.range = r}

        func sexp(_ indentation: Swift.String) -> Swift.String
        { return indentation+"(\(state) \(range))" }
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

            t[StrippedTransitionPair(kInt, k.range)] = vInt
        }

        return t
    }()

    func _endState(for t: TransitionPair) -> ItemSet
    { return t.itemSet.reduce(ItemSet()) { $0.union($1.move(over: t.range)) } }

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

            /*
             *if rest.isEmpty { self.init(first) }
             *else            { self.init(SBERT(Set(values.dropFirst()))!
             *                            .inserting(first)) }
             */

            var sbert = SBERT(first)
            for e in rest
            {
                sbert = sbert.inserting(e)
            }
            self.init(sbert)
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

fileprivate extension AST.Regex
{
    typealias TokenDefinition            = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias ElementaryRange = LexerGenerator.ElementaryRange
    typealias ItemSet         = Set<Regex>

    func move(over r: ElementaryRange) -> ItemSet
    {
        guard let repetitionOperator = self.repetitionOperator
        else { return basicRegex.move(over: r) }

        switch repetitionOperator
        {
        case .zeroOrOne:
            return BasicRegex.epsilon.move(over: r)
                .union(Regex(basicRegex: basicRegex,
                             repetitionOperator: nil).move(over: r))

        case .zeroOrMore:
            return BasicRegex.epsilon.move(over: r)
                .union(Regex(basicRegex: basicRegex,
                             repetitionOperator: .oneOrMore).move(over: r))

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
                repetitionOperator: nil).move(over: r)
        }
    }
}

fileprivate extension AST.BasicRegex
{
    typealias TokenDefinition            = AST.TokenDefinition
    typealias Regex           = AST.Regex
    typealias BasicRegex      = AST.BasicRegex
    typealias CharacterSet    = AST.CharacterSet
    typealias ElementaryRange = LexerGenerator.ElementaryRange
    typealias ItemSet         = Set<Regex>

    func move(over r: ElementaryRange) -> ItemSet
    {
        switch self
        {
        case let .regex(regex): return regex.move(over: r)

        case .epsilon: return ItemSet()

        case let .union(left, right):
            return left.move(over: r).union(right.move(over: r))

        case let .concatenation(left, right):
            return Set(left.move(over: r).map
            { regex in
                Regex(
                    basicRegex: .concatenation(regex, right),
                    repetitionOperator: nil)
            })

        case let .characterSet(characterSet):
            return characterSet.contains(r) ? ItemSet([Regex()]) : ItemSet()
        }
    }
}
