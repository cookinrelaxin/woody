import Foundation

protocol ElementaryRangeQueryable
{
    subscript(_ s: Scalar) -> ElementaryRange? { get }
    subscript(_ s: ScalarRange) -> Set<ElementaryRange> { get }
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
