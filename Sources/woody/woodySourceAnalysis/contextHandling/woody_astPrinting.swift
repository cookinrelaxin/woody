import Foundation

extension ScalarRange: SEXPPrintable
{
    func sexp(_ indentation: String) -> String
    {
        let l = String(format: "U+%X", lowerBound.value)
        let u = String(format: "U+%X", upperBound.value)

        if lowerBound == upperBound
        {
            return "\(indentation)\(l)"
        }

        return "\(indentation)(scalarRange \(l) \(u))"
    }
}
