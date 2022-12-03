import
  strutils,
  operators,
  ../types


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
