import
  json,
  strutils,
  tables,
  operators,
  ../types


let setAttribute*: SetAttrributeFunc =
  func(parser: ParserFunc, attributeName: string,
      nodeType: NodeType): ParserFunc =
    return proc(src: ParserFuncSrc): ParserFuncDest =
      let dest = parser(src)
      if dest.isSucceeded:
        var newDest = dest
        if dest.node.attributes == Attributes():
          newDest.attributes[attributeName] = Node(
            nodeType: nodeType,
            value: dest.parsed
          )
        else:
          newDest.attributes[attributeName] = dest.node
        echo "Set Attribute: ", (%*newDest).pretty()
        return newDest
      return dest

let returnNode*: ReturnNodeFunc =
  func(parser: ParserFunc, nodeType: NodeType): ParserFunc =
    return proc(src: ParserFuncSrc): ParserFuncDest =
      let dest = parser(src)
      if dest.isSucceeded:
        var newDest = dest
        newDest.node = Node(
          nodeType: nodeType,
          attributes: dest.attributes
        )
        newDest.attributes = Attributes()
        echo "Return Node: ", (%*newDest).pretty()
        return newDest
      return dest

let anyCharParser*: ParserFunc =
  proc(src: ParserFuncSrc): ParserFuncDest =
    if src.len() > 0:
      return ParserFuncDest(
        isSucceeded: true,
        parsed: src[0],
        remained: src[1..^1]
      )
    return ParserFuncDest(
      isSucceeded: false,
      remained: src
    )

let specifiedCharParser*: SpecifiedCharFunc =
  func(c: char): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      let dest = anyCharParser(src)
      if not dest.isSucceeded or dest.parsed != $c:
        return ParserFuncDest(
          isSucceeded: false,
          remained: src
        )
      if dest.parsed == $c:
        return dest

let specifiedStrParser*: SpecifiedStrFunc =
  func(s: string): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      if src.len() >= s.len():
        if src[0..s.len()-1].join("") == s:
          return ParserFuncDest(
            isSucceeded: true,
            parsed: s,
            remained: src[s.len()..^1]
          )
      return ParserFuncDest(
        isSucceeded: false,
        remained: src
      )

let upperCaseAlphabetParser*: ParserFunc =
  proc(src: ParserFuncSrc): ParserFuncDest =
    let dest = anyCharParser(src)
    if dest.parsed.len() > 0:
      let c = dest.parsed[0]
      if c.isUpperAscii():
        return dest
    return ParserFuncDest(
      isSucceeded: false,
      remained: src
    )

let lowerCaseAlphabetParser*: ParserFunc =
  proc(src: ParserFuncSrc): ParserFuncDest =
    let dest = anyCharParser(src)
    if dest.parsed.len() > 0:
      let c = dest.parsed[0]
      if c.isLowerAscii():
        return dest
    return ParserFuncDest(
      isSucceeded: false,
      remained: src
    )

let alphabetParser*: ParserFunc = upperCaseAlphabetParser | lowerCaseAlphabetParser

let alphabetsParser*: ParserFunc = alphabetParser.repeatOperator(1, -1)

let digitParser*: ParserFunc =
  proc(src: ParserFuncSrc): ParserFuncDest =
    let dest = anyCharParser(src)
    if dest.parsed.len() > 0:
      let c = dest.parsed[0]
      if c.isDigit():
        return ParserFuncDest(
          isSucceeded: true,
          parsed: $c,
          remained: dest.remained
        )
    return ParserFuncDest(
      isSucceeded: false,
      remained: src
    )

let alphabetOrDigitParser*: ParserFunc = alphabetParser | digitParser

let notZeroParser*: ParserFunc =
  proc(src: ParserFuncSrc): ParserFuncDest =
    let dest = digitParser(src)
    if not dest.isSucceeded or dest.parsed == "0":
      return ParserFuncDest(
        isSucceeded: false,
        remained: src
      )
    return dest

let minusParser*: ParserFunc = specifiedCharParser('-')

let intengerParser*: ParserFunc =
  minusParser.repeatOperator(0, 1) +~
  (
    digitParser |
    notZeroParser +~ digitParser.repeatOperator(0, -1)
  )

let dotParser*: ParserFunc = specifiedCharParser('.')

let floatParser*: ParserFunc =
  minusParser.repeatOperator(0, 1) +~
  (
    notZeroParser.notOperator() |
    (
      notZeroParser +~ digitParser.repeatOperator(0, -1)
    )
  ) +~
  dotParser +~
  digitParser.repeatOperator(1, -1)

let numberParser*: ParserFunc = intengerParser | floatParser

let whitespaceParser*: ParserFunc = specifiedCharParser(' ')

let whitespacesParser*: ParserFunc = whitespaceParser.repeatOperator(1, -1)

let newlineParser*: ParserFunc = specifiedCharParser('\n')

let identifierParser*: ParserFunc =
  alphabetsParser +~ alphabetOrDigitParser.repeatOperator(0, -1)

let operatorParser*: ParserFunc =
  specifiedCharParser('+') |
  specifiedCharParser('-') |
  specifiedCharParser('*') |
  specifiedCharParser('/')

let expressionParser*: ParserFunc =
  (
    numberParser.setAttribute("left", NodeType.Literal) +~
      whitespaceParser.repeatOperator(0, -1) +~
    operatorParser.setAttribute("operator", NodeType.Operator) +~
      whitespaceParser.repeatOperator(0, -1) +~
    numberParser.setAttribute("right", NodeType.Literal)
  ).returnNode(NodeType.Expression)
