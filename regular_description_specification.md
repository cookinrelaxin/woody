# Regular Description specification

This document comprises the specification of WoodyRDL, including its complete
grammar. Non-terminals are denoted in camel-case.

## Tokens
The rules below whose arrows are of the form '=>' indicate token class definitions.
For reference, we compile every token class below, in lexing order:

identifier       => identifierHead­identifierCharacter*
helperArrow      => '->'
tokenArrow       => '=>'
semicolon        => ';'
leftParenthesis  => '('
rightParenthesis => ')'
bar              => '|'
star             => '*'
plus             => '+'
question         => '?'
caret            => '^'
dollar           => '$'
string           => doubleQuote character+ doubleQuote
unicode          => u | period
ascii            => 'A'
character        => character_literal | codepoint
leftBracket      => '{'
rightBracket     => '}'
setSeparator     => ','
dash             => '-'

We also have the token class `erroneous`, which comprises any single character
which is not in another token class.

## Whitespace and comments

Whitespace and comments are insignificant.

### Whitespace and comment grammar

whitespace     -> whitespaceItem+
whitespaceItem -> U+0000 | U+0009 | U+000B | U+000C | U+0020
                | lineBreak
lineBreak      -> U+000A | U+000D | U+000D U+000A

comment     -> '#'­commentText­lineBreak
commentText -> [^U+000A U+000D]*

## Identifiers

Woody uses identifiers to represent non-terminals. The identifier grammar is
based on that of Swift.

### Identifier grammar

identifier => identifierHead­identifierCharacter*

#### Basic Latin
identifierHead -> U+0041-U+005A | U+0061-U+007A

identifierHead -> _­

#### Misc. Latin-1 Supplement

identifierHead -> U+00A8 | U+00AA | U+00AD | U+00AF | U+00B2–U+00B5 | U+00B7–U+00BA
identifierHead -> U+00BC–U+00BE | U+00C0–U+00D6 | U+00D8–U+00F6 | U+00F8–U+00FF

#### Latin Extended A & B, IPA Extensions, and misc. Spacing Modifier Letters

identifierHead -> U+0100–U+02FF

#### Greek and Coptic, Cyrillic, Cyrillic Supplement, Armenian, Hebrew, Arabic,
Syriac, Arabic Supplement, Thaana, NKo, Smaritan, Mandaic, Syriac Supplement,
Arabic Extended-A, Devanagari, Bengali, Gurmukhi, Gujarati, Oriya, Tamil,
Telugu, Kannada, Malayalam, Sinhala, Thai, Lao, Tibetan, Myanmar, Georgian,
Hangul Jamo, Ethiopic, Ethiopic Supplement, Cherokee, Unified Canadian
Aboriginal Syllabics

identifierHead -> U+0370–U+167F

Skip Ogham space mark

#### Ogham, Runic, Tagalog, Hanunoo, Buhid, Tagbanwa, KHmer, initial mongolian

identifierHead -> U+1681–U+180D

Skip mongolian separators

#### Mongolian, ...
identifierHead -> U+180F–U+1DBF


identifierHead -> U+200B–U+200D | U+202A–U+202E | U+203F–U+2040 | U+2054
                 | U+2060–U+206F

identifierHead -> U+2070–U+20CF | U+2100–U+218F | U+2460–U+24FF |  U+2776–U+2793

identifierHead -> U+2C00–U+2DFF  U+2E80–U+2FFF

identifierHead -> U+3004–U+3007 | U+3021–U+302F | U+3031–U+303F |  U+3040–U+D7FF

identifierHead -> U+F900–U+FD3D | U+FD40–U+FDCF | U+FDF0–U+FE1F |  U+FE30–U+FE44

identifierHead -> U+FE47–U+FFFD

identifierHead -> U+10000–U+1FFFD | U+20000–U+2FFFD | U+30000–U+3FFFD
                 | U+40000–U+4FFFD

identifierHead -> U+50000–U+5FFFD | U+60000–U+6FFFD | U+70000–U+7FFFD
                 | U+80000–U+8FFFD

identifierHead -> U+90000–U+9FFFD | U+A0000–U+AFFFD | U+B0000–U+BFFFD
                 | U+C0000–U+CFFFD

identifierHead -> U+D0000–U+DFFFD | U+E0000–U+EFFFD

identifierCharacter -> identifierHead­

identifierCharacter -> [0-9]

identifierCharacter -> U+0300–U+036F | U+1DC0–U+1DFF | U+20D0–U+20FF
                      | U+FE20–U+FE2F

## Regular Descriptions

### Regular Description Grammar

#### Rules

regularDescription -> rule+
rule            -> identifier arrow regex semicolon
regex           -> groupedRegex | ungroupedRegex
groupedRegex    -> leftParenthesis regex rightParenthesis
ungroupedRegex  -> union | simpleRegex
union           -> regex bar simpleRegex
simpleRegex     -> concatenation | basicRegex
concatenation   -> simpleRegex basicRegex
basicRegex      -> elementaryRegex repetitionOperator?
elementaryRegex -> positionOperator | string | identifier | set

#### Rule Symbols
In order of appearance in the "Rules" section

arrow -> helperArrow | tokenArrow
    helperArrow => '->'
    tokenArrow  => '=>'

semicolon => ';'

leftParenthesis  => '('
rightParenthesis => ')'

bar => '|'

repetitionOperator -> star | plus | question
    star     => '*'
    plus     => '+'
    question => '?'

positionOperator -> caret | dollar
    caret  => '^'
    dollar => '$'

string => doubleQuote character+ doubleQuote
    doubleQuote -> '"'

#### Sets

set          -> simpleSet (minus simpleSet)?
simpleSet    -> standardSet | literalSet
standardSet  -> Unicode | ASCII
literalSet   -> basicSet | bracketedSet
basicSet     -> character | range
bracketedSet -> leftBracket basicSetList rightBracket
basicSetList -> basicSet | basicSet basicSetSeparator basicSetList

#### Set symbols

minus -> '\'

The set of all Unicode codepoints
unicode => u | period
    u       -> 'U'
    period  -> '.'

The set of all ASCII codepoints
ascii => 'A'

character => character_literal | codepoint
    character_literal -> quote .
        quote -> '''
    codepoint         -> 'u' digits

range -> character dash character
    dash => '-'

leftBracket => '{'
rightBracket => '}'

setSeparator => ','

#### Digits

digits   -> hexDigit
digits   -> hexDigit hexDigit
digits   -> hexDigit hexDigit hexDigit
digits   -> hexDigit hexDigit hexDigit hexDigit
digits   -> hexDigit hexDigit hexDigit hexDigit hexDigit
digits   -> hexDigit hexDigit hexDigit hexDigit hexDigit hexDigit
hexDigit -> [0-9a-fA-F]

## Notes

TODO: Clarify the string grammar, specifically regarding escape characters.

We impose the further restriction that each non-terminal must be fully defined
before it is used.

The only escaped characters are literal characters, which are escaped group-wise
by surrounding them with '. Hence, if α and β are strings, then 'α''β' has an
identical meaning to 'αβ'.

TODO: What about in sets?

`character` is undefined above, but it may be any unicode character. Any occurennce
of the character ' in a string must be escaped with a backslash. Any occurennce
in a range must be escaped with a backslash?

The point of escaping literal characters is to make it possible to read
indentifiers embedded within regular expressions.