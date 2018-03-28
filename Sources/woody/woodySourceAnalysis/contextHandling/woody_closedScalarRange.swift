import Foundation

struct ScalarRange: Equatable, Hashable
{
    let lowerBound: Scalar
    let upperBound: Scalar

    init(_ scalar: Scalar)
    {
        lowerBound = scalar
        upperBound = scalar
    }

    init(_ range: ClosedRange<Scalar>)
    {
        lowerBound = range.lowerBound
        upperBound = range.upperBound
    }

    func contains(_ r: ElementaryRange) -> Bool
    {
        let l: UInt32
        let u: UInt32

        switch r
        {
            case let .scalar(s)            : l = s.value; u = s.value
            case let .discreteSegment(s,t) : l = s.value+1; u = t.value-1
        }

        return lowerBound.value <= l && u <= upperBound.value
    }
}

