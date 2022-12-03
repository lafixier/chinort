import ../types


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
