import Foundation

final class Reader
{
    static let encoding: String.Encoding = .utf8

    let source: URL
    let fileHandle: FileHandle
    lazy var data: String.UnicodeScalarView? =
    {
        let data = fileHandle.readDataToEndOfFile()
        let string = String(data: data, encoding: Reader.encoding)
        let scalars = string?.unicodeScalars

        return scalars
    }()

    init(source: URL) throws
    {
        self.source = source
        fileHandle = try FileHandle(forReadingFrom: source)
    }
}
