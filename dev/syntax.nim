import types


let SyntaxRules* = @[
  SyntaxRule(
    name: "VariableDefinition",
    pattern: @[Def, Identifier, ColonEqual, Number]
  )
]
