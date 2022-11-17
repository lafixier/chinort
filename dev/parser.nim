import
  strformat,
  syntax,
  types


type Parser* = ref object
  tokens: seq[Token]
  syntaxRules: seq[SyntaxRule]
  sentences: seq[seq[Token]]

proc init(parser: Parser) =
  parser.syntaxRules = SyntaxRules
  parser.sentences = @[]

proc readTokens(parser: Parser) =
  var maybeMatchedSyntaxRule: SyntaxRule
  var sentence: seq[Token] = @[]
  for i, token in parser.tokens:
    if i == 0:
      for syntaxRule in parser.syntaxRules:
        if token.kind == syntaxRule.pattern[0]:
          maybeMatchedSyntaxRule = syntaxRule
    if token.kind == maybeMatchedSyntaxRule.pattern[i]:
      sentence.add(token)
    else:
      echo fmt"Error: Expected {maybeMatchedSyntaxRule.pattern[i]}, but {token.kind} was given."
      return
  # 暫定処置
  parser.sentences.add(sentence)
  echo parser.sentences


proc parse*(parser: Parser, tokens: seq[Token]) =
  parser.tokens = tokens
  parser.init()
  parser.readTokens()
