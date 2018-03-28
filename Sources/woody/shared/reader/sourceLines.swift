import Foundation

struct Source: Equatable, Hashable
{
    struct Index: Equatable, Hashable, Comparable, CustomDebugStringConvertible
    {
        let line: Int
        let char: Int

        init(line: Int, char: Int)
        {
            self.line = line
            self.char = char
        }

        init(_ pair: (Int, Int))
        {
            self.line = pair.0
            self.char = pair.1
        }

        static func < (lhs: Index, rhs: Index) -> Bool
        {
            return (lhs.line < rhs.line) ||
                   ((lhs.line == rhs.line) && (lhs.char < rhs.char))
        }

        var debugDescription: Swift.String
        { return "(Index \(line) \(char))" }
    }

    struct ClosedRange: Equatable, Hashable
    {
        let start : SourceLines.Index
        let end   : SourceLines.Index
    }

    private let data: [[Scalar]]
    let url: URL

    init(lines: [[Scalar]], url: URL) { self.data = lines; self.url = url }

    subscript(_ line: Int) -> [Scalar]
    { return data[line] }

    subscript(_ index: Index) -> Scalar
    { return data[index.line][index.char] }

    subscript(_ range: ClosedRange<Index>) -> [Scalar]
    {
        var scalars = [Scalar]()
        var index = range.lowerBound

        while index <= range.upperBound
        {
            scalars.append(self[index])
            index = self.index(after: index)
        }

        return scalars
    }

    func string(in range: ClosedRange<Index>) -> String
    { return String(String.UnicodeScalarView(self[range])) }

    func line(for index: Index) -> String
    {
        let l = index.line

        let i1 = Index(line: l, char: 0)
        let i2 = Index(line: l, char: data[l].count-1)

        return string(in: i1...i2)
    }

    let startIndex = Index(line: 0, char: 0)
    var endIndex: Index
    { return Index(line: data.count-1, char: data[data.count-1].count-1) }

    func index(before index: Index) -> Index
    {
        let newLine: Int
        let newChar: Int

        switch index.char
        {
        case 0:
            newLine = index.line - 1
            newChar = data[newLine].count - 1

        case let char:
            newLine = index.line
            newChar = char - 1
        }

        return Index(line: newLine, char: newChar)
    }

    func index(after index: Index) -> Index
    {
        let newLine: Int
        let newChar: Int

        switch index.char
        {
        case data[index.line].count-1:
            newLine = index.line + 1
            newChar = 0

        case let char:
            newLine = index.line
            newChar = char + 1
        }

        return Index(line: newLine, char: newChar)
    }

    static func ==(l: SourceLines, r: SourceLines) -> Bool
    { return l.url == r.url }

    var hashValue: Int { return url.hashValue }
}
