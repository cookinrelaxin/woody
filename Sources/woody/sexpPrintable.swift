import Foundation

let standardIndentation = " "

protocol SEXPPrintable: CustomDebugStringConvertible
{
    func print(_ indentation: Swift.String) -> Swift.String
}

extension SEXPPrintable
{
    var debugDescription: Swift.String { return print("") }
}
