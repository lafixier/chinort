import
  strformat,
  syntax,
  types


type Parser* = ref object
  tokens: seq[Token]
  syntaxRules: seq[SyntaxRule]
  sentence: seq[Token]

proc init(parser: Parser) =
  parser.syntaxRules = SyntaxRules
  parser.sentence = @[]

proc readTokens(parser: Parser) =
  var maybeMatchedSyntaxRule: SyntaxRule
  for i, token in parser.tokens:
    if i == 0:
      for syntaxRule in parser.syntaxRules:
        if token.kind == syntaxRule.pattern[0]:
          maybeMatchedSyntaxRule = syntaxRule
    if token.kind == maybeMatchedSyntaxRule.pattern[i]:
      parser.sentence.add(token)
    else:
      echo fmt"Error: Expected {maybeMatchedSyntaxRule.pattern[i]}, but {token.kind} was given."
      return
  echo parser.sentence


proc parse*(parser: Parser, tokens: seq[Token]) =
  parser.tokens = tokens
  parser.init()
  parser.readTokens()
