# Regular Description specification

This document comprises the specification of WoodyRDL, including its complete
grammar.

## Tokens
The rules below whose arrows are of the form '=>' indicate token definitions.
For reference, we compile every token class below, in lexing order:

identifier        => identifier-head­identifier-character*
string            => quote character+ quote
arrow             => helper_arrow | token_arrow
bar               => '|'
star              => '*'
plus              => '+'
question          => '?'
period            => '.'
dollar            => '$'
caret             => '^'
quote             => '''
left_parenthesis  => '('
right_parenthesis => ')'
left_bracket      => '['
right_bracket     => ']'
minus             => '-'
semicolon         => ';'

We also have the token class `erroneous`, which comprises any single character
which is not in another token class.

## Whitespace and comments

Woody uses whitespace to separate tokens in the source file and to identify
rules. However, whitespace and comments should be considered insignificant.

### Whitespace grammar

whitespace      -> whitespace-item+
whitespace-item -> U+0000 | U+0009 | U+000B | U+000C | U+0020
                 | line-break­| comment
line-break      -> U+000A | U+000D | U+000D U+000A
comment         -> ';'­comment-text­line-break
comment-text    -> [^U+000A U+000D]*

## Identifiers

Woody uses identifiers to represent non-terminals. The identifier grammar is
based on that of Swift.

### Identifier grammar

identifier => identifier-head­identifier-character*

Basic Latin
identifier-head -> U+0041-U+005A | U+0061-U+007A

identifier-head -> _­

Misc. Latin-1 Supplement
identifier-head -> U+00A8 | U+00AA | U+00AD | U+00AF | U+00B2–U+00B5 | U+00B7–U+00BA
identifier-head -> U+00BC–U+00BE | U+00C0–U+00D6 | U+00D8–U+00F6 | U+00F8–U+00FF

Latin Extended A & B, IPA Extensions, and misc. Spacing Modifier Letters
identifier-head -> U+0100–U+02FF

Greek and Coptic, Cyrillic, Cyrillic Supplement, Armenian, Hebrew, Arabic,
Syriac, Arabic Supplement, Thaana, NKo, Smaritan, Mandaic, Syriac Supplement,
Arabic Extended-A, Devanagari, Bengali, Gurmukhi, Gujarati, Oriya, Tamil,
Telugu, Kannada, Malayalam, Sinhala, Thai, Lao, Tibetan, Myanmar, Georgian,
Hangul Jamo, Ethiopic, Ethiopic Supplement, Cherokee, Unified Canadian
Aboriginal Syllabics
identifier-head -> U+0370–U+167F

Skip Ogham space mark

Ogham, Runic, Tagalog, Hanunoo, Buhid, Tagbanwa, KHmer, initial mongolian

identifier-head -> U+1681–U+180D

Skip mongolian separators

Mongolian, ...
identifier-head -> U+180F–U+1DBF


identifier-head -> U+200B–U+200D | U+202A–U+202E | U+203F–U+2040 | U+2054
                 | U+2060–U+206F

identifier-head -> U+2070–U+20CF | U+2100–U+218F | U+2460–U+24FF |  U+2776–U+2793

identifier-head -> U+2C00–U+2DFF  U+2E80–U+2FFF

identifier-head -> U+3004–U+3007 | U+3021–U+302F | U+3031–U+303F |  U+3040–U+D7FF

identifier-head -> U+F900–U+FD3D | U+FD40–U+FDCF | U+FDF0–U+FE1F |  U+FE30–U+FE44

identifier-head -> U+FE47–U+FFFD

identifier-head -> U+10000–U+1FFFD | U+20000–U+2FFFD | U+30000–U+3FFFD
                 | U+40000–U+4FFFD

identifier-head -> U+50000–U+5FFFD | U+60000–U+6FFFD | U+70000–U+7FFFD
                 | U+80000–U+8FFFD

identifier-head -> U+90000–U+9FFFD | U+A0000–U+AFFFD | U+B0000–U+BFFFD
                 | U+C0000–U+CFFFD

identifier-head -> U+D0000–U+DFFFD | U+E0000–U+EFFFD

identifier-character -> identifier-head­

identifier-character -> [0-9]

identifier-character -> U+0300–U+036F | U+1DC0–U+1DFF | U+20D0–U+20FF
                      | U+FE20–U+FE2F

## Regular Descriptions

### Regular Description Grammar

#### Symbols

arrow               => helper_arrow | token_arrow
helper_arrow        -> '->'
token_arrow         -> '=>'

bar                 => '|'
star                => '*'
plus                => '+'
question            => '?'
period              => '.'
dollar              => '$'
caret               => '^'
quote               => '''
left_parenthesis    => '('
right_parenthesis   => ')'
left_bracket        => '['
right_bracket       => ']'
minus               => '-'
semicolon           => ';'

repetition_operator -> star | plus | question
position_operator  -> caret | dollar

#### Rules

regular_description -> rule+
rule                -> identifier arrow regex semicolon
regex               -> union | simple_regex
union               -> regex bar simple_regex
simple_regex        -> concatenation | basic_regex
concatenation       -> simple_regex basic_regex
basic_regex         -> elementary_regex repetition_operator?
elementary_regex    -> group | position_operator | string | identifier | period
                     | set

group               -> left_parenthesis regex right_parenthesis
string              => quote character+ quote

#### Sets

set                 -> positive_set | negative_set
positive-set        -> left_bracket set_item* right_bracket
negative-set        -> left_bracket caret set_item* right_bracket
set-item            -> range | character
range               -> character minus character

## Notes

We impose the further restriction that each non-terminal must be fully defined
before it is used.

The only escaped characters are literal characters, which are escaped group-wise
by surrounding them with '. Hence, if α and β are strings, then 'α''β' has an
identical meaning to 'αβ'.

`character` is undefined above, but it may be any unicode character. Any occurennce
of the character ' in a string must be escaped with a backslash.

The point of escaping literal characters is to make it possible to read
indentifiers embedded within regular expressions.
