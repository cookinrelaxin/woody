import Foundation

typealias AST = AbstractSyntaxTree

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

fileprivate func toScalar(_ lCharacter: Lexer.Character) -> Scalar
{
    let s = lCharacter.representation
    switch (s.first!)
    {
    case "u":
        return Scalar(UInt32(s.dropFirst(), radix: 16)!)!

    case "'":
        return s.dropFirst().unicodeScalars.first!

    default: fatalError()
    }
}

extension ParseTree
{
    var flattened: [Rule]
    {
        var rules = [Rule]()

        switch regularDescription
        {
        case let .cat(rule, possibleRules):
            rules.append(rule)

            switch possibleRules
            {
            case let .cat(actualRules):
                rules.append(contentsOf: actualRules)
            }
        }

        return rules
    }

    static func unique(in rules: [Rule]) -> [Rule]
    {
        return rules.reduce([Rule]())
        { _rules, rule in
            var a = _rules

            switch rule
            { case let .cat(id1, d, _, _):
                switch d
                { case .helperDefinitionMarker(_): break
                  case .tokenDefinitionMarker(_):
                      if !_rules.contains
                      { r in
                          switch r
                          {
                          case let .cat(id2,_,_,_):
                              return id1.representation == id2.representation
                          }
                      }
                      { a.append(rule) }
                }
            }

            return a
        }
    }
}

struct AbstractSyntaxTree: Equatable, Hashable
{
    typealias OrderedPRegex = Context.OrderedPRegex

    let rules: [TokenDefinition]

    var hashValue: Int { return rules.count }

    init(parseTree: ParseTree, sourceLines: SourceLines)
    {
        let pRules: [ParseTree.Rule] = parseTree.flattened

        let idLookup = pRules.enumerated().reduce(Context.IDLookup())
        { dict, pair in
            let (i, pRule) = pair
            var _dict = dict

            switch pRule
            {
            case let .cat(id, _, pRegex, _):
                let key = id.representation
                if let s = _dict[key]
                {
                    let order = s.first!.order
                    _dict[key] = s.union([OrderedPRegex(pRegex, order)])
                }
                else { _dict[key] = [OrderedPRegex(pRegex, i)] }
            }

            return _dict
        }

        let context = Context(idLookup: idLookup, sourceLines: sourceLines)

        var rules = [TokenDefinition]()

        do
        {
            rules = try ParseTree.unique(in: pRules)
                             .map { try TokenDefinition(pRule: $0, context) }
        }
        catch let ContextHandlingError.undefinedIdentifier(id)
        {
            ContextHandlingError.print(.undefinedIdentifier(id), context)
            exit(1)
        }
        catch let e
        {
            print(e)
            exit(1)
        }

        self.rules = rules
    }

    struct TokenDefinition: Equatable, Hashable
    {
        let tokenClass : String
        let order      : Int
        let regex      : Regex

        init(_ tokenClass: String, _ order: Int, _ regex: Regex)
        {
            self.tokenClass = tokenClass
            self.order      = order
            self.regex      = regex
        }

        init(pRule: ParseTree.Rule, _ context: Context) throws
        {
            switch pRule
            {
            case let .cat(id, _, pRegex, _):
                self.tokenClass = String(id.representation)
                guard let orderedPRegex = context.idLookup[tokenClass]
                else { throw ContextHandlingError.undefinedIdentifier(id) }

                self.order      = orderedPRegex.first!.order
                try self.regex  = Regex(pRegex: pRegex, context)
            }
        }
    }

    struct Regex: Equatable, Hashable
    {
        let basicRegex         : BasicRegex
        let repetitionOperator : RepetitionOperator?

        var hashValue: Int { return basicRegex.hashValue }

        init()
        {
            basicRegex         = .epsilon
            repetitionOperator = nil
        }

        init(basicRegex: BasicRegex, repetitionOperator: RepetitionOperator?)
        {
            self.basicRegex         = basicRegex
            self.repetitionOperator = repetitionOperator
        }

        init(pRegexes: Set<ParseTree.Regex>, _ context: Context) throws
        {
            switch pRegexes.count
            {
            case 0: basicRegex = .epsilon
            case 1: basicRegex = try .regex(Regex(pRegex: pRegexes.first!,
                                                  context))
            default:
                basicRegex = try
                .union(Regex(pRegex: pRegexes.first!, context),
                       Regex(pRegexes: Set(pRegexes.dropFirst()),
                             context))
            }

            repetitionOperator = nil
        }

        init(pRegex: ParseTree.Regex, _ context: Context) throws
        {
            switch pRegex
            {
            case let .groupedRegex(pGroupedRegex):
                try self.init(pGroupedRegex: pGroupedRegex, context)
            case let .ungroupedRegex(pUngroupedRegex):
                try self.init(pUngroupedRegex: pUngroupedRegex, context)
            }
        }

        init(pGroupedRegex: ParseTree.GroupedRegex, _ context: Context) throws
        {
            switch pGroupedRegex
            {
            case let .cat(_, _pRegex, _, pRepetitionOperator):
                basicRegex = try BasicRegex(pRegex: _pRegex, context)
                repetitionOperator = RepetitionOperator(pRepetitionOperator:
                                                        pRepetitionOperator)
            }
        }

        init(pUngroupedRegex: ParseTree.UngroupedRegex, _ context: Context)
        throws
        {
            switch pUngroupedRegex
            {
            case let .union(pUnion):
                try self.init(pUnion: pUnion, context)

            case let .simpleRegex(pSimpleRegex):
                try self.init(pSimpleRegex: pSimpleRegex, context)
            }
        }

        init(pUnion: ParseTree.Union, _ context: Context) throws
        {
            basicRegex = try BasicRegex(pUnion: pUnion, context)
            repetitionOperator = nil
        }

        init(pConcatenation: ParseTree.Concatenation, _ context: Context) throws
        {
            basicRegex = try BasicRegex(pConcatenation: pConcatenation, context)
            repetitionOperator = nil
        }

        init(pSimpleRegex: ParseTree.SimpleRegex, _ context: Context) throws
        {
            switch pSimpleRegex
            {
            case let .concatenation(pConcatenation):
                try self.init(pConcatenation: pConcatenation, context)

            case let .basicRegex(pBasicRegex):
                try self.init(pBasicRegex: pBasicRegex, context)
            }
        }

        init(pBasicRegex: ParseTree.BasicRegex, _ context: Context) throws
        {
            switch pBasicRegex
            {
            case let .cat(pElementaryRegex, pRepetitionOperator):
                switch pElementaryRegex
                {
                case let .string(lString):
                    self.init(basicRegex:
                        try Regex(lString: lString, context).basicRegex,
                        repetitionOperator:
                            RepetitionOperator(pRepetitionOperator:
                                               pRepetitionOperator))

                case let .identifier(lIdentifier):
                    self.init(basicRegex:
                        try Regex(lIdentifier: lIdentifier, context).basicRegex,
                        repetitionOperator:
                            RepetitionOperator(pRepetitionOperator:
                                               pRepetitionOperator))

                case let .set(pSet):
                    self.init(basicRegex:
                        .characterSet(CharacterSet(pSet: pSet, context)),
                              repetitionOperator:
                        RepetitionOperator(pRepetitionOperator:
                              pRepetitionOperator))
                }
            }
        }

        init(lString: Lexer.String, _ context: Context) throws
        {
            let unquoted = String(lString.representation.dropFirst().dropLast())

            try self.init(string: unquoted, context)
        }

        init(string: String, _ context: Context) throws
        {
            if string.isEmpty { basicRegex = .epsilon }
            else
            {
                let first   : Scalar  = string.unicodeScalars.first!
                let charset : BasicRegex = .characterSet(CharacterSet(first))
                let rest    : String     = String(string.dropFirst())
                let r1 = Regex(basicRegex: charset, repetitionOperator: nil)
                let r2 = try Regex(string: String(rest), context)

                if string.count == 1 { basicRegex = .regex(r1) }
                else                 { basicRegex = .concatenation(r1, r2) }
            }

            repetitionOperator = nil
        }

        init(lIdentifier: Lexer.Identifier, _ context: Context) throws
        {
            let key = lIdentifier.representation
            guard let orderedPRegexes = context.idLookup[key]
            else
            { throw ContextHandlingError.undefinedIdentifier(lIdentifier) }

            let pRegexes = orderedPRegexes.reduce(Set<ParseTree.Regex>())
            { $0.union([$1.pRegex]) }

            try self.init(pRegexes: pRegexes, context)
        }
    }

    indirect enum BasicRegex: Equatable, Hashable
    {
        case regex         (Regex)
        case epsilon
        case union         (Regex, Regex)
        case concatenation (Regex, Regex)
        case characterSet  (CharacterSet)

        init(pRegex: ParseTree.Regex, _ context: Context) throws
        { self = try .regex(Regex(pRegex: pRegex, context)) }

        init(pUnion: ParseTree.Union, _ context: Context) throws
        {
            switch pUnion
            {
            case let .cat(pSimpleRegex, _, pRegex):
                let r1 = try Regex(pSimpleRegex: pSimpleRegex, context)
                let r2 = try Regex(pRegex: pRegex, context)

                self = .union(r1, r2)
            }
        }

        init(pConcatenation: ParseTree.Concatenation, _ context: Context) throws
        {
            switch pConcatenation
            {
            case let .cat(pBasicRegex, pSimpleRegex):
                let r1 = try Regex(pBasicRegex: pBasicRegex, context)
                let r2 = try Regex(pSimpleRegex: pSimpleRegex, context)

                if r2.basicRegex == .epsilon { self = .regex(r1) }
                else                         { self = .concatenation(r1, r2) }
            }
        }


    }

    enum RepetitionOperator: Equatable, Hashable
    {
        case zeroOrOne
        case zeroOrMore
        case oneOrMore

        init?(pRepetitionOperator: ParseTree.RepetitionOperator?)
        {
            guard let pRepetitionOperator = pRepetitionOperator
            else { return nil }

            switch pRepetitionOperator
            {
                case .zeroOrOneOperator(_)  : self = .zeroOrOne
                case .zeroOrMoreOperator(_) : self = .zeroOrMore
                case .oneOrMoreOperator(_)  : self = .oneOrMore
            }
        }
    }

    struct CharacterSet: Equatable, Hashable
    {
        let positiveSet: Set<ScalarRange>
        let negativeSet: Set<ScalarRange>

        init(_ scalar: Scalar)
        {
            positiveSet = Set([ScalarRange(scalar)])
            negativeSet = Set()
        }

        init(pSet: ParseTree.Set, _ context: Context)
        {
            switch pSet
            {
            case let .cat(pSimpleSet, pSetSubtraction):
                self.positiveSet = CharacterSet._set(for: pSimpleSet, context)
                self.negativeSet = CharacterSet._set(for: pSetSubtraction,
                    context)
            }
        }

        func contains(_ r: ElementaryRange) -> Bool
        {
            func contained(in set: Set<ScalarRange>) -> Bool
            { return set.contains { $0.contains(r) } }

            return contained(in: positiveSet) && !contained(in: negativeSet)
        }

        private static func _set(for pSimpleSet: ParseTree.SimpleSet, _ context:
            Context)
        -> Set<ScalarRange>
        {
            switch pSimpleSet
            {
                case let .standardSet(pStandardSet):
                    return CharacterSet._set(for: pStandardSet, context)
                case let .literalSet(pLiteralSet):
                    return CharacterSet._set(for: pLiteralSet, context)
            }
        }

        private static func _set(for pStandardSet: ParseTree.StandardSet, _
            context: Context) -> Set<ScalarRange>
        {
            let range = Scalar(UInt32(0))! ... Scalar(UInt32(0x100000))!

            switch pStandardSet
            {
                case .cat(_): return Set([ScalarRange(range)])
            }
        }

        private static func _set(for pLiteralSet: ParseTree.LiteralSet, _
            context: Context) -> Set<ScalarRange>
        {
            switch pLiteralSet
            {
                case let .basicSet(pBasicSet):
                    return CharacterSet._set(for: pBasicSet, context)

                case let .bracketedSet(pBracketedSet):
                    return CharacterSet._set(for: pBracketedSet, context)
            }
        }

        private static func _set(for pBasicSet: ParseTree.BasicSet, _ context:
            Context) -> Set<ScalarRange>
        {
            switch pBasicSet
            {
                case let .range(pRange):
                    return CharacterSet._set(for: pRange, context)

                case let .character(pCharacter):
                    return CharacterSet._set(for: pCharacter, context)
            }
        }

        private static func _set(for pBracketedSet: ParseTree.BracketedSet, _
            context: Context) ->
        Set<ScalarRange>
        {
            switch pBracketedSet
            {
                case let .cat(_, pBasicSetList, _):
                    return CharacterSet._set(for: pBasicSetList, context)
            }
        }

        private static func _set(for pBasicSetList: ParseTree.BasicSetList, _
            context: Context) -> Set<ScalarRange>
        {
            switch pBasicSetList
            {
                case let .basicSets(pBasicSets):
                    return CharacterSet._set(for: pBasicSets, context)

                case let .basicSet(pBasicSet):
                    return CharacterSet._set(for: pBasicSet, context)
            }
        }

        private static func _set(for pBasicSets: ParseTree.BasicSets, _ context:
            Context) -> Set<ScalarRange>
        {
            switch pBasicSets
            {
                case let .cat(pBasicSet, _, pBasicSetList):
                    return CharacterSet._set(for: pBasicSet,
                        context).union(CharacterSet._set(for: pBasicSetList,
        context))
            }
        }

        private static func _set(for pRange: ParseTree.Range,
                                 _ context: Context) -> Set<ScalarRange>
        {
            switch pRange
            {
                case let .cat(c1, _, c2):
                    let s1 = toScalar(c1)
                    let s2 = toScalar(c2)

                    return Set([ScalarRange(s1...s2)])
            }
        }

        private static func _set(for lCharacter: Lexer.Character, _ context:
            Context) -> Set<ScalarRange>
        {
            return Set([ScalarRange(toScalar(lCharacter))])
        }

        private static func _set(for pSetSubtraction: ParseTree.SetSubtraction?,
   _ context: Context)
        -> Set<ScalarRange>
        {
            guard let pSetSubtraction = pSetSubtraction
            else { return Set<ScalarRange>() }

            switch pSetSubtraction
            {
                case let .cat(_, pSimpleSet): return CharacterSet._set(for:
                    pSimpleSet, context)
            }
        }
    }
}
