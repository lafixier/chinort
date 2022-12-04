import
  base,
  operators,
  ../types


let identifierParser*: ParserFunc =
  alphabetsParser +~ alphabetOrDigitParser.repeatOperator(0, -1)
