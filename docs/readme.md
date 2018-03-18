# Woody -- a lexical analyzer generator for Swift-implemented programming
languages.

## Synopsis

For a given problem domain, scripting and domain-specific languages, abbreviated respectively as SLs and DSLs, can offer arbitrarily higher levels of abstraction than a given general purpose programming language.

Woody is a lexical analyzer generator for Swift-implemented programming
languages. That is, given regular descriptions (defined below) of the tokens of
a programming language P, Woody will output Swift code which accepts arbitrary
source text written in P and returns a stream of tokens, as defined by the user.

## WoodyRDL

The Woody Regular Description Language (WoodyRDL) is a high-level language for
specifying the tokens of a given programming language P.

### Example

TODO (see example.woody).

## Usage

The modularity of Woody enables it to be incorporated into a language
implementation, only requiring that it accept tokens of type `Token` (as defined by
the generated program), and calls the single public interface function provided
by the generated program, `nextToken() -> Token?`.

`Token` will be a struct...
