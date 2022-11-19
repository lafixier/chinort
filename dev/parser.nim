import
  strformat,
  tables,
  syntax,
  types


type Parser* = ref object
  tokens: seq[Token]
  syntaxRules: seq[SyntaxRule]
  sentences: seq[Sentence]
  ast: Ast
  nextNodeId: int

proc init(parser: Parser) =
  parser.syntaxRules = syntaxRules
  parser.sentences = @[]
  parser.ast = Ast()
  parser.ast.root = @[]
  parser.nextNodeId = -1

proc readTokens(parser: Parser) =
  var maybeMatchedSyntaxRule: SyntaxRule
  var sentence: Sentence
  for i, token in parser.tokens:
    if i == 0:
      for syntaxRule in parser.syntaxRules:
        if token.kind == syntaxRule.pattern[0].kind:
          maybeMatchedSyntaxRule = syntaxRule
    let patternToken = maybeMatchedSyntaxRule.pattern[i]
    if token.kind == patternToken.kind:
      sentence.readTokens.add(ReadToken(token: token,
          patternToken: patternToken))
      sentence.syntaxRule = maybeMatchedSyntaxRule
    else:
      echo fmt"Error: Expected {patternToken.kind}, but {token.kind} was given."
      return
  # 暫定処置
  parser.sentences.add(sentence)
  # echo parser.sentences

proc getNextNodeId(parser: Parser): string =
  parser.nextNodeId += 1
  return $parser.nextNodeId

proc generateAst(parser: Parser) =
  for sentence in parser.sentences:
    var node = Node(nodeId: parser.getNextNodeId, parentNodesIds: @["root"])
    var attributes: Table[string, string]
    for readToken in sentence.readTokens:
      if readToken.patternToken.attributeName != "":
        attributes[readToken.patternToken.attributeName] = readToken.token.value
    node.syntax = Syntax(rule: sentence.syntaxRule, attributes: attributes)
    parser.ast.root.add(node)

proc parse*(parser: Parser, tokens: seq[Token]): Ast =
  parser.tokens = tokens
  parser.init()
  parser.readTokens()
  parser.generateAst()
  return parser.ast
