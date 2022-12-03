import
  ../types


let anyChar*: ParserFunc =
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

let specifiedChar*: SpecifiedCharFunc =
  func(c: char): ParserFunc =
    return proc (src: ParserFuncSrc): ParserFuncDest =
      let dest = anyChar(src)
      if not dest.isSucceeded or dest.parsed != $c:
        return ParserFuncDest(
          isSucceeded: false,
          remained: src
        )
      if dest.parsed == $c:
        return dest
