import tables


type ParserFuncSrc* = seq[string]

type ParserFuncDest* = object
  isSucceeded*: bool
  parsed*: string
  remained*: ParserFuncSrc

type ParserFunc* = proc(src: ParserFuncSrc): ParserFuncDest

type SpecifiedCharFunc* = proc(c: char): ParserFunc

type SpecifiedStrFunc* = proc(s: string): ParserFunc

type OrOperatorFunc* = proc(parsers: seq[ParserFunc]): ParserFunc

type RepeatOperatorFunc* =
  proc(parser: ParserFunc, min: int, max: int): ParserFunc

type JoinOperatorFunc* = proc(parsers: seq[ParserFunc]): ParserFunc

type NotOperatorFunc* = proc(parser: ParserFunc): ParserFunc
