import tables


type NodeType* {.pure.} = enum
  VariableDefinition
  Expression
  Literal
  Operator

type Node* = object
  nodeType*: NodeType
  value*: string
  attributes*: Table[string, Node]

type Attributes* = Table[string, Node]

type ParserFuncSrc* = seq[string]

type ParserFuncDest* = object
  isSucceeded*: bool
  parsed*: string
  remained*: ParserFuncSrc
  attributes*: Attributes
  node*: Node

type ParserFunc* = proc(src: ParserFuncSrc): ParserFuncDest

type SpecifiedCharFunc* = proc(c: char): ParserFunc

type SpecifiedStrFunc* = proc(s: string): ParserFunc

type OrOperatorFunc* = proc(parsers: seq[ParserFunc]): ParserFunc

type RepeatOperatorFunc* =
  proc(parser: ParserFunc, min: int, max: int): ParserFunc

type JoinOperatorFunc* = proc(parsers: seq[ParserFunc]): ParserFunc

type NotOperatorFunc* = proc(parser: ParserFunc): ParserFunc

type SetAttrributeFunc* =
  proc(parser: ParserFunc, attributeName: string,
      nodeType: NodeType): ParserFunc

type ReturnNodeFunc* =
  proc(parser: ParserFunc, nodeType: NodeType): ParserFunc
