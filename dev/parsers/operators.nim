import
  strutils,
  ../types


template `|`*(a, b: ParserFunc): ParserFunc = orOperator(@[a, b])

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
        remained: remained
      )
