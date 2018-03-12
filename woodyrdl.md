# WoodyRDL

## Synopsis

The Woody Regular Description Language, or WoodyRDL for short, is the primary
interface by which users interact with Woody. Specifically users write files in
WoodyRDL, which Woody then reads and uses to generate the desired lexical
analyzer.

The purpose of a WoodyRDL file is to completely describe a set of tokens, which
are usually intended to be the tokens of a programming language.

## Examples

See example.woody for an example of a basic WoodyRDL file.

## Specification

Tokens are described by means of a "regular description", which is simply a
context-free grammar with the property that each non-terminal must be defined
before it is used.

### Question

How do we deal with regular expressions?

Non-terminals are defined as follows:

`id arrow body`,

`id` represents the left-hand side of a production and is any identifier of the
form TODO.

`arrow` is of the form (-> | =>). If `=>` is used, then the definition is a
token description.

`body` is of the form TODO.

## Implementation (for contributors)

### Synopsis

Since WoodyRDL is simple, its own lexical analyzer and parser can be
hand-written.

The output of Woody is Swift code which defines a type for each _token class_
(not to be confused with swift classes), and an interface for retrieving tokens.

### Token representation

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

### Pipeline

The initial modules in Woody form a pipeline as follows:

Reader -> Lexical Analyzer -> Substitutor -> Parser -> ...

- The reader is responsible for reading the .woody file into an input buffer.

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
