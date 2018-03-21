import Foundation

struct Context
{
    typealias IDLookup = [String : Set<ParseTree.Regex>]

    let idLookup: IDLookup
    let sourceLines: SourceLines
}
