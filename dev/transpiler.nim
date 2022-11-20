import
  strformat,
  tables,
  syntax,
  types


type Transpiler* = ref object
  ast: Ast
  dest: string
  syntaxRules: seq[SyntaxRule]

proc init(transpiler: Transpiler) =
  transpiler.ast = Ast()
  transpiler.dest = ""
  transpiler.syntaxRules = syntaxRules

proc transpile2nim(transpiler: Transpiler) =
  for node in transpiler.ast.root:
    var matchedSyntaxRule: SyntaxRule
    for syntaxRule in transpiler.syntaxRules:
      if node.syntax.rule == syntaxRule:
        matchedSyntaxRule = syntaxRule
    echo matchedSyntaxRule
    case matchedSyntaxRule.name
    of "VariableDefinition":
      let variableName = node.syntax.attributes["variableName"]
      let value = node.syntax.attributes["value"]
      transpiler.dest &= fmt"var {variableName} = {value}"
  # echo transpiler.dest


proc transpile*(transpiler: Transpiler, ast: Ast,
    targetLang: TargetLangs): string =
  transpiler.init()
  transpiler.ast = ast
  case targetLang:
  of TargetLangs.Nim:
    transpiler.transpile2nim()
  return transpiler.dest
