import Foundation

indirect enum Regex: Equatable, Hashable
{
    case ε
    case oneOrMore     (Regex)
    case union         (Regex, Regex)
    case concatenation (Regex, Regex)
    case characterSet  (CharacterSet)

    static func +(_ l: Regex, _ r: Regex) -> Regex
    {
        switch (l, r)
        {
            case (ε, _) : return r
            case (_, ε) : return l
            default     : return .concatenation(l, r)
        }
    }

    init(regex: Regex, pRepetitionOperator: ParseTree.RepetitionOperator?)
    {
        guard let pRepetitionOperator = pRepetitionOperator
        else { self = regex; return }

        switch pRepetitionOperator
        {
        case .zeroOrMoreOperator(_): self = .union(.ε, .oneOrMore(regex))

        case .oneOrMoreOperator(_): self = .oneOrMore(regex)

        case .zeroOrOneOperator(_): self = .union(.ε, regex)
        }
    }

    init(pRegexes: Set<ParseTree.Regex>, _ context: Context) throws
    {
        switch pRegexes.count
        {
        case 0: self = .ε
        case 1: self = try Regex(pRegex: pRegexes.first!, context)
        default:
            self = try
            .union(Regex(pRegex: pRegexes.first!, context),
                   Regex(pRegexes: Set(pRegexes.dropFirst()),
                         context))
        }
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
            let r = try Regex(pRegex: _pRegex, context)
            self.init(regex: r, pRepetitionOperator: pRepetitionOperator)
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

            self = .concatenation(r1, r2)
        }
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
            let r: Regex

            switch pElementaryRegex
            {
            case let .string(lString):
                r = try Regex(lString: lString, context)

            case let .identifier(lIdentifier):
                r = try Regex(lIdentifier: lIdentifier, context)

            case let .set(pSet):
                r = Regex.characterSet(CharacterSet(pSet: pSet, context))
            }

            self.init(regex: r, pRepetitionOperator: pRepetitionOperator)
        }
    }

    init(lString: Lexer.String, _ context: Context) throws
    {
        let unquoted = String(lString.representation.dropFirst().dropLast())

        try self.init(string: unquoted, context)
    }

    init(string: String, _ context: Context) throws
    {
        if string.isEmpty { self = .ε }
        else
        {
            let first   : Scalar  = string.unicodeScalars.first!
            let charset : Regex = .characterSet(CharacterSet(first))
            let rest    : String     = String(string.dropFirst())
            let r1 = charset
            let r2 = try Regex(string: String(rest), context)

            if string.count == 1 { self = r1 }
            else                 { self = .concatenation(r1, r2) }
        }
    }

    init(lIdentifier: Lexer.Identifier, _ context: Context) throws
    {
        let key = lIdentifier.representation

        guard !context.boundIdentifiers.contains(key)
        else
        {
            throw ContextHandlingError.recursiveTokenDefinition(lIdentifier)
        }

        guard let orderedPRegexes = context.idLookup[key]
        else { throw ContextHandlingError.undefinedIdentifier(lIdentifier) }

        let pRegexes = orderedPRegexes.reduce(Set<ParseTree.Regex>())
        { $0.union([$1.pRegex]) }

        let newContext = Context(context, key)

        try self.init(pRegexes: pRegexes, newContext)
    }
}

