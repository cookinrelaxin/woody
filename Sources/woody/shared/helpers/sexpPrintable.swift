import Foundation

let standardIndentation = "  "

protocol SEXPPrintable: CustomDebugStringConvertible
{
    func sexp(_ indentation: Swift.String) -> Swift.String
}

extension SEXPPrintable
{
    var debugDescription: Swift.String { return sexp("") }
}
