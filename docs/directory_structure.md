# Directory Structure

```text
lafixier/chinort/
├── README.md                   # Readme
├── .husky/                     # Husky configuration
├── .vscode/                    # VSCode configuration
├── dev/                        # Source codes under development
│   ├── lexer.nim               # Lexical analyzer
│   ├── parser.nim              # Parser
│   ├── parsers/                # Parser combinators
│   │   ├── advanced.nim        # Advanced parser combinators
│   │   ├── base.nim            # Fundamental parser combinators
│   │   └── operators.nim       # Operators for the parser combinators
│   ├── test.nim                # Test script
│   ├── transpiler.nim          # Transpiler
│   └── types.nim               # User defined types
├── docs/                       # Documentation
│   ├── directory_structure.md  # Directory structure (This file)
│   └── lang_specification.md   # Language specification
├── nim_fmt.py                  # Auto formatter for Nim files
├── notes/                      # Notes for developing
│   └── ast_examples/           # AST examples
│       ├── ast.json
│       ├── ast_example_1.json
│       ├── ast_example_2.json
│       ├── easy_ast_1.json
│       └── easy_ast_2.json
├── package.json                # Node.js package.json
└── yarn.lock                   # Yarn lockfile
```
