import lexer

proc main() =
  let lexer = Lexer()
  const src = "def a : = 1"
  lexer.lex(src)

main()
