import
  lexer,
  parser,
  transpiler,
  types

proc main() =
  let lexer = Lexer()
  let parser = Parser()
  let transpiler = Transpiler()
  const src = "def a := 1"
  let tokens = lexer.lex(src)
  let ast = parser.parse(tokens)
  let dest = transpiler.transpile(ast, TargetLangs.Nim)


main()
