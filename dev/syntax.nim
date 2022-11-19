import types


let syntaxRules* = @[
  SyntaxRule(
    name: "VariableDefinition",
    pattern: @[
      PatternToken(kind: TokenKind.Def, attributeName: ""),
      PatternToken(kind: TokenKind.Identifier, attributeName: "variableName"),
      PatternToken(kind: TokenKind.ColonEqual, attributeName: ""),
      PatternToken(kind: TokenKind.Number, attributeName: "value"), ]
  )
]
