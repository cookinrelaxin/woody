# WoodyRDL

## Synopsis

The Woody Regular Description Language, or WoodyRDL for short, is the primary
interface by which users interact with Woody. Specifically users write files in
WoodyRDL, which Woody then reads and uses to generate the desired lexical
analyzer.

The purpose of a WoodyRDL file is to completely describe a set of tokens,
which are usually intended to be the tokens of a programming language.

See example.woody for an example of a basic WoodyRDL file.

## Specification

Tokens are described by means of a "regular description", which is simply a
context-free grammar with the property that each non-terminal must
be defined before it is used.

Non-terminals are defined as follows:

`id arrow body`,

`id` represents the left-hand side of a production and is any identifier of the
form TODO.

`arrow` is of the form (-> | =>). If `=>` is used, then the definition is a
token description.

`body` is of the form TODO.

## Implementation (for contributors)
