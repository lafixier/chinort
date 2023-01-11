import
  types


type Parser* = ref object
  src: ParserSrc


proc init(parser: Parser) =
  discard

proc parse*(parser: Parser, src: ParserSrc) =
  parser.init()
  parser.src = src
