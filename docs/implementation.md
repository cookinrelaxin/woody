# Implementation (for contributors)

## Pipeline overview

The basic conceptual model for Woody's architecture is the pipeline composed of
a sequence of functional modules (not to be confused with Swift modules). For
simplicity, Woody is an exclusively broad compiler. That is, each module
performs its work at most once. So, for instance, the lexical analyzer returns a
list of every token in the input string, rather than one token at a time.

The 'front end' is as follows:

Reader -> Lexical Analyzer -> Parser -> Substitutor -> ...

### Reader

Input: A path or url to a utf-8-encoded .woody file `f`.
Output: a string containing the contents of `f`.

### Lexical Analyzer

Input: A string `s`.
Output: A list of every token in the input string.

### Parser

....

### Substitutor

The Substitutor performs forward substitution on identifiers within rule bodies
until each body contains exclusively terminals.

...

### ...
...

## The Pipeline Coordinator

Neither of pipeline modules is 'in charge'. Each is a more-or-less functional
unit with no knowledge of the rest of the program. Hence the pipeline must be
coordinated by some central manager. That is the role of Pipeline Coordinator.

The pipeline coordinator is initialized with a path or url, initializes the
pipeline modules, and feeds data in and out of each module until all input data
is exhausted and the target program has been generated completely.

The pipeline coordinator sits between the internal pipeline modules and the
user-facing API.

## The Reader in depth

...

##

...

Input: a list of tokens
- The reader abstracts away the details of file input and is responsible for returning the contents of a .woody file as a `String`.

- The lexical analyzer is responsible for forming a list of tokens as described
  by the WoodyRDL specification.

- The substitutor accepts the token lists and performs on it _forward
  substitution_, by which previously defined terminals in the body of each rule
  are substituted by their respective bodies. The output is a list of named
  proper regular expressions, whose bodies contain exclusively terminals.

- Finally, the parser receives the regular expression list and outputs an
  abstract syntax tree (AST).

The next modules in the pipeline are as follows:

... -> Item Set Constructor -> Transition Table Generator -> ???

## Synopsis

Since WoodyRDL is simple, its own lexical analyzer and parser are hand-written.

The output of Woody is Swift code which defines a type for each _token class_
(not to be confused with swift classes), and an interface for retrieving tokens.

## Token representation

In WoodyRDL, users define various _token classes_. For example, `integer` may be
the token class describing all strings of the form `[0-9]+`.
Hence, in the generated code, (GC), a Swift type should be defined for each
given token class. In keeping with functional design principles, classes are out
of the question. Careful consideration reveals that an `enum` is the best
representation.

Hence all GC will define a `Token` type, of the form

`
enum Token {
    case class1(TokenInfo)
    case class2(TokenInfo)
    .
    .
    .
    case classN(TokenInfo)
}
`,

where `TokenInfo` is a struct containing the string representation of the token,
its line and character number in the source code, and other possible
information.

### Token retrieval interface

Woody supports both broad and narrow compiler pipelines. The former will request
a list of all tokens at once, and will then never call the lexical analyzer
again. A narrow compiler, on the other hand, will repeatedly call the lexical
analyzer for the next token.

For reasons of elegance, it makes sense to define both of these functions on the
Token type, so that the API surface may be as small as possible.

`
enum Token {
    .
    .
    .

    static tokens: [Token] { ... }
    static nextToken: Token? { ... }
}
`

This is just a sketch. It may make sense to define a protocol or two.


