type TokenKind* {.pure.} = enum
  Identifier
  Def = "def"
  Colon = ":"
  Equal = "="
  Newline = "\n"
  Number


type Token* = object
  value*: string
  kind*: TokenKind
