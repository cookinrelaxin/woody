import Foundation

typealias SBERT = SelfBalancingElementaryRangeTree

final class SelfBalancingElementaryRangeTree: SEXPPrintable,
ElementaryRangeQueryable
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

    subscript(_ s: Scalar) -> ElementaryRange?
    { return _range(for: .scalar(s)) }

    private func _range(for r: ElementaryRange) -> ElementaryRange?
    {
        /*print("find \(r) in \(self)")*/
        if r < value      { return left?._range(for: r) }
        else if r > value { return right?._range(for: r) }
        else              { return value }
    }

    subscript(_ s: ScalarRange) -> Set<ElementaryRange>
    {
        if s < value { return left?[s] ?? [] }
        if value < s { return right?[s] ?? [] }

        return (s.contains(value) ? Set([value]) : Set([]))
               .union(left?[s] ?? [])
               .union(right?[s] ?? [])
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
