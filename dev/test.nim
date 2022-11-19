import
  lexer,
  parser

proc main() =
  let lexer = Lexer()
  let parser = Parser()
  const src = "def a := 1"
  let tokens = lexer.lex(src)
  parser.parse(tokens)

main()
