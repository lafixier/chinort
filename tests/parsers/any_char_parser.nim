discard """
  exitcode: 0
"""


import
  nre,
  sequtils,
  tables,
  ../../dev/types,
  ../../dev/parsers/base


const expected = @[
  ParserFuncDest(
    isSucceeded: true,
    parsed: "a",
    remained: @[],
    attributes: Attributes()
  ),
  ParserFuncDest(
    isSucceeded: true,
    parsed: "A",
    remained: @[],
    attributes: Attributes(),
    node: Node(
      nodeType: NodeType.VariableDefinition, value: "", attributes: Attributes()
    )
  ),
  ParserFuncDest(
    isSucceeded: true,
    parsed: "0",
    remained: @[],
    attributes: Attributes(),
    node: Node(
      nodeType: NodeType.VariableDefinition, attributes: Attributes()
    )
  ),
  ParserFuncDest(
    isSucceeded: true,
    parsed: "\n",
    remained: @[],
    attributes: Attributes(),
    node: Node(
      nodeType: NodeType.VariableDefinition, attributes: Attributes()
    )
  )
]
const srcs = @["a", "A", "0", "\n"]
let parserSrcs = srcs.map(proc (s: string): seq[string] = s.split(re""))
for i, parserSrc in parserSrcs:
  let dest = base.anyCharParser(parserSrc)
  doAssert dest == expected[i]
