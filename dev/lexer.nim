import types


type Lexer* = ref object
  src: string
  tokensSplittedWithSpaces: seq[string]
  tokens: seq[Token]
  token: Token

proc init(lexer: Lexer) =
  lexer.src = ""
  lexer.tokensSplittedWithSpaces = @[]
  lexer.tokens = @[]

proc splitWithSpaces(lexer:Lexer) =
  var isInsideQuotes = false
  var token = ""
  for i, character in lexer.src:
    if character == '"':
      if isInsideQuotes:
        isInsideQuotes = false
        token &= character
        lexer.tokensSplittedWithSpaces.add(token)
        token = ""
        continue
      else:
        isInsideQuotes = true
        token &= character
        continue
    if character == ' ':
      lexer.tokensSplittedWithSpaces.add(token)
      token = ""
    else:
      token &= character
    if i == lexer.src.len - 1:
      lexer.tokensSplittedWithSpaces.add(token)

proc addToken(lexer: Lexer) =
  if lexer.token.value.len > 0:
    lexer.tokens.add(lexer.token)
    lexer.token = Token()

proc lex*(lexer: Lexer, src: string) =
  lexer.init()
  lexer.src = src
  lexer.splitWithSpaces()
  lexer.token = Token()
  for i, token in lexer.tokensSplittedWithSpaces:
    case token
    of $TokenKind.Def:
      lexer.token.value = token
      lexer.token.kind = TokenKind.Def
      lexer.addToken()
    of $TokenKind.Colon:
      lexer.token.value = token
      lexer.token.kind = TokenKind.Colon
      lexer.addToken()
    of $TokenKind.Equal:
      lexer.token.value = token
      lexer.token.kind = TokenKind.Equal
      lexer.addToken()
    of "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
      lexer.token.value = token
      lexer.token.kind = TokenKind.Number
      lexer.addToken()
    else:
      lexer.token.value = token
      lexer.token.kind = TokenKind.Identifier
      lexer.addToken()
