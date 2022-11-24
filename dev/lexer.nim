import types


type Lexer* = ref object
  symbols: seq[char]
  src: string
  tokens: seq[Token]
  token: Token

proc init(lexer: Lexer) =
  lexer.symbols = @['!', '"', '#', '$', '%', '&', '\'', '(', ')', '-', '=', '^',
      '~', '\\', '|', '@', '`', '[', '{', ';', '+', ':', '*', ']', '}', ',',
      '<', '.', '>', '/', '?', '_', '\n']
  lexer.src = ""
  lexer.tokens = @[]
  lexer.token = Token(value: "", kind: TokenKind.NotDetermined)

proc addToken(lexer: Lexer) =
  if lexer.token.value.len() != 0:
    lexer.tokens.add(lexer.token)
    lexer.token = Token(kind: TokenKind.NotDetermined)

proc splitIntoTokens(lexer: Lexer) =
  var isPreviousTokenSymbol = false
  # var isInsideQuotes = false
  for i, character in lexer.src:
    # 文字が空白である場合
    if character == ' ':
      lexer.addToken()
      isPreviousTokenSymbol = false
    # 文字が空白でない場合
    else:
      # 文字が記号である場合
      if character in lexer.symbols:
        # 文字が記号であり、かつ前の文字も記号である場合
        if isPreviousTokenSymbol:
          lexer.token.value &= character
        # 文字が記号であり、かつ前の文字が記号でない場合
        else:
          lexer.addToken()
          lexer.token.value &= character
          isPreviousTokenSymbol = true
      # 文字が記号でない場合
      else:
        # 文字が記号ではなく、かつ前の文字が記号である場合
        if isPreviousTokenSymbol:
          lexer.addToken()
          lexer.token.value &= character
          isPreviousTokenSymbol = false
        # 文字が記号ではなく、かつ前の文字も記号でない場合
        else:
          lexer.token.value &= character
      # 最終文字の場合、addTokenする
      if i == lexer.src.len() - 1:
        lexer.addToken()

proc addKinds2Tokens(lexer: Lexer) =
  proc discrimeTokenKind(tokenValue: string): TokenKind =
    case tokenValue:
    of $TokenKind.Newline:
      TokenKind.Newline
    of $TokenKind.Def:
      TokenKind.Def
    of $TokenKind.Colon:
      TokenKind.Colon
    of $TokenKind.Equal:
      TokenKind.Equal
    of $TokenKind.ColonEqual:
      TokenKind.ColonEqual
    of "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
      TokenKind.Number
    else:
      TokenKind.Identifier
  for i, token in lexer.tokens:
    lexer.tokens[i].kind = discrimeTokenKind(token.value)


proc lex*(lexer: Lexer, src: string): seq[Token] =
  lexer.init()
  lexer.src = src
  lexer.splitIntoTokens()
  lexer.addKinds2Tokens()
  return lexer.tokens
