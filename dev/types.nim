import tables

type TokenKind* {.pure.} = enum
  NotDetermined
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

type TokenRead* = object
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
  readTokens*: seq[TokenRead]
  syntaxRule*: SyntaxRule

type TargetLangs* = enum
  Nim

type ParserFuncSrc* = seq[string]

type ParserFuncDest* = object
  isSucceeded*: bool
  parsed*: string
  remained*: ParserFuncSrc

type ParserFunc* = proc(src: ParserFuncSrc): ParserFuncDest

type SpecifiedCharFunc* = proc(c: char): ParserFunc

type SpecifiedStrFunc* = proc(s: string): ParserFunc

type OrOperatorFunc* = proc(parser: seq[ParserFunc]): ParserFunc

type RepeatOperatorFunc* =
  proc(parser: ParserFunc, min: int, max: int): ParserFunc
