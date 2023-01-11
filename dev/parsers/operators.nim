import
  json,
  strutils,
  tables,
  ../types


template `|`*(a, b: ParserFunc): ParserFunc = orOperator(@[a, b])

template `+~`*(a, b: ParserFunc): ParserFunc = joinOperator(@[a, b])

proc mergeTwoTables[T, S](a, b: Table[T, S]): Table[T, S] =
  # echo (%*a).pretty()
  # echo (%*b).pretty()
  var merged = a
  for key, value in b.pairs:
    merged[key] = value
  echo "Merged Table: ", (%*merged).pretty()
  return merged

let orOperator*: OrOperatorFunc =
  func(parsers: seq[ParserFunc]): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      for parser in parsers:
        let dest = parser(src)
        if dest.isSucceeded:
          return dest
      return ParserFuncDest(
        isSucceeded: false,
        remained: src
      )

let repeatOperator*: RepeatOperatorFunc =
  func(parser: ParserFunc, min: int, max: int): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      var parsed: seq[string] = @[]
      var dest = parser(src)
      if not dest.isSucceeded:
        if min == 0:
          return ParserFuncDest(
            isSucceeded: true,
            parsed: parsed.join(""),
            remained: src,
            attributes: dest.attributes,
            node: dest.node
          )
        return ParserFuncDest(
          isSucceeded: false,
          parsed: parsed.join(""),
          remained: src
        )
      parsed.add(dest.parsed)
      var remained = dest.remained
      var i = 1
      while i < max or max < 0:
        dest = parser(remained)
        if not dest.isSucceeded:
          break
        parsed.add(dest.parsed)
        remained = dest.remained
        i += 1
      if i < min:
        return ParserFuncDest(
          isSucceeded: false,
          remained: src
        )
      return ParserFuncDest(
        isSucceeded: true,
        parsed: parsed.join(""),
        remained: remained,
        attributes: dest.attributes,
        node: dest.node
      )

let joinOperator*: JoinOperatorFunc =
  func(parsers: seq[ParserFunc]): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      var parsed = ""
      var remained = src
      var attributes = Attributes()
      var node = Node()
      for parser in parsers:
        let dest = parser(remained)
        if not dest.isSucceeded:
          return ParserFuncDest(
            isSucceeded: false,
            remained: src
          )
        parsed.add(dest.parsed)
        remained = dest.remained
        attributes = mergeTwoTables(attributes, dest.attributes)
        node = dest.node
      return ParserFuncDest(
        isSucceeded: true,
        parsed: parsed,
        remained: remained,
        attributes: attributes,
        node: node
      )

let notOperator*: NotOperatorFunc =
  func(parser: ParserFunc): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      let dest = parser(src)
      if dest.isSucceeded:
        return ParserFuncDest(
          isSucceeded: false
        )
      return ParserFuncDest(
        isSucceeded: true,
        remained: src,
        attributes: dest.attributes,
        node: dest.node
      )
