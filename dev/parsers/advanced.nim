import
  operators,
  ../types,
  base

let variableDefinitionParser*: ParserFunc =
  (
    specifiedStrParser("def") +~
      whitespaceParser.repeatOperator(0, -1) +~
    identifierParser.setAttribute("variableName", NodeType.Literal) +~
      whitespaceParser.repeatOperator(0, -1) +~
    specifiedStrParser(":=") +~
      whitespaceParser.repeatOperator(0, -1) +~
    expressionParser.setAttribute("value", NodeType.Expression)
  ).returnNode(NodeType.VariableDefinition)
