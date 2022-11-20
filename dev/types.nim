import tables

type TokenKind* {.pure.} = enum
  Identifier = "[a-zA-Z_]\\w*"
  Def = "def"
  Colon = ":"
  Equal = "="
  ColonEqual = $Colon & $Equal
  Newline = "\n"
  Number = "\\d"


type Token* = object
  value*: string
  kind*: TokenKind

type PatternToken* = object
  kind*: TokenKind
  attributeName*: string

type SyntaxRule* = object
  name*: string
  pattern*: seq[PatternToken]

type ReadToken* = object
  token*: Token
  patternToken*: PatternToken

type Syntax* = object
  rule*: SyntaxRule
  attributes*: Table[string, string]

type Node* = object
  nodeId*: string
  parentNodesIds*: seq[string]
  syntax*: Syntax
  childNodes*: seq[Node]

type Ast* = object
  root*: seq[Node]

type Sentence* = object
  readTokens*: seq[ReadToken]
  syntaxRule*: SyntaxRule

type TargetLangs* = enum
  Nim
