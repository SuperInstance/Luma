# STATE — Luma

## Status
Active — Forked from upstream, being agentified

## Last Sync
2026-04-14

## Current Phase
Bootstrapping as git-agent

## Capabilities
- ✅ Lexer — tokenizes .lx source files
- ✅ Parser — generates AST
- ✅ Type checker — ownership-aware static analysis
- ✅ LLVM backend — code generation
- ✅ LSP — language server protocol support
- ✅ Arena allocator — custom memory management
- ✅ Formatter — code formatting
- ✅ Test suite — unit tests + integration (chess engine, 3D cube, string tests)
- ✅ Makefile + configure — standard C build system
- ✅ Doxygen — documentation generation
- ✅ Nix flake — reproducible builds

## Architecture
```
src/
├── ast/         — Abstract syntax tree nodes
├── auto_docs/   — Automatic documentation generation
├── c_libs/      — C library bindings (memory, etc.)
├── helper/      — CLI helpers, argument parsing
├── lexer/       — Lexical analysis (tokenization)
├── llvm/        — LLVM IR generation
├── lsp/         — Language Server Protocol
├── parser/      — Syntax parsing (tokens → AST)
└── typechecker/ — Static analysis + ownership verification
```

## Build
```bash
make              # Build the compiler
./luma build file.lx   # Compile a Luma source file
make test         # Run tests
```
