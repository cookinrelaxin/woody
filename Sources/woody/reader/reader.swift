import Foundation

final class Reader
{
    static let encoding: Swift.String.Encoding = .utf8

    let source: URL
    let fileHandle: FileHandle
    lazy var data: SourceLines =
    {
        let data = fileHandle.readDataToEndOfFile()
        let string = Swift.String(data: data, encoding: Reader.encoding)

        var lines = [[Scalar]]()
        var line = [Scalar]()
        for s in string!.unicodeScalars
        {
            line.append(s)
            if isLinebreak(s)
            {
                lines.append(line)
                line = [Scalar]()
            }
        }

        return SourceLines(lines: lines, url: source)
    }()

    init(source: URL)
    {
        self.source = source
        do
        {
            fileHandle = try FileHandle(forReadingFrom: source)
        }
        catch let e
        {
            print("Unexpected error in reader: \(e)")
            exit(1)
        }
    }
}
