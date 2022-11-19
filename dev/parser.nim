import
  strformat,
  syntax,
  types


type Parser* = ref object
  tokens: seq[Token]
  syntaxRules: seq[SyntaxRule]
  sentences: seq[Sentence]

proc init(parser: Parser) =
  parser.syntaxRules = SyntaxRules
  parser.sentences = @[]

proc readTokens(parser: Parser) =
  var maybeMatchedSyntaxRule: SyntaxRule
  var sentence: Sentence = @[]
  for i, token in parser.tokens:
    if i == 0:
      for syntaxRule in parser.syntaxRules:
        if token.kind == syntaxRule.pattern[0].kind:
          maybeMatchedSyntaxRule = syntaxRule
    let patternToken = maybeMatchedSyntaxRule.pattern[i]
    if token.kind == patternToken.kind:
      sentence.add(ReadToken(token: token, patternToken: patternToken))
    else:
      echo fmt"Error: Expected {patternToken.kind}, but {token.kind} was given."
      return
  # 暫定処置
  parser.sentences.add(sentence)
  echo parser.sentences


proc parse*(parser: Parser, tokens: seq[Token]) =
  parser.tokens = tokens
  parser.init()
  parser.readTokens()
