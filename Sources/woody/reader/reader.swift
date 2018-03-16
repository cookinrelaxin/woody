import Foundation

final class Reader
{
    static let encoding: Swift.String.Encoding = .utf8

    let source: URL
    let fileHandle: FileHandle
    lazy var data: Swift.String.UnicodeScalarView? =
    {
        let data = fileHandle.readDataToEndOfFile()
        let string = Swift.String(data: data, encoding: Reader.encoding)
        let scalars = string?.unicodeScalars

        return scalars
    }()

    init(source: URL) throws
    {
        self.source = source
        fileHandle = try FileHandle(forReadingFrom: source)
    }
}
