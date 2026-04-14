# BOOTCAMP — Luma Agent Training

## Quick Start (5 minutes)
1. Read this file + CHARTER.md + STATE.md
2. Build the compiler: `make`
3. Run a test: `./luma build tests/test.lx`
4. Check the task board: `cat TASK-BOARD.md`
5. Pick a task and start working

## Architecture Overview
Luma is a compiler written in C with these stages:
```
Source (.lx) → Lexer → Tokens → Parser → AST → Type Checker → LLVM IR → Machine Code
```

Each stage has its own directory under `src/`:
- `lexer/` — character → token conversion
- `parser/` — token → AST tree construction
- `ast/` — AST node definitions
- `typechecker/` — static analysis + ownership verification
- `llvm/` — LLVM IR generation
- `c_libs/` — utility libraries (memory arena, etc.)
- `helper/` — CLI argument parsing, build config
- `lsp/` — Language Server Protocol support

## Key Design Decisions
1. **Arena allocator** — all compiler memory comes from arenas, freed in bulk
2. **Ownership annotations** — `#takes_ownership`, `#returns_ownership` for static analysis
3. **No borrow checker** — manual memory management, compiler catches common errors
4. **LLVM backend** — leverages LLVM optimization passes
5. **.lx file extension** — Luma source files

## How to Add a Feature
1. Understand the pipeline stage you're modifying
2. Add tests first (in `tests/`)
3. Implement the feature
4. Verify all existing tests still pass
5. Commit with descriptive message + [luma] attribution

## How to Fix a Bug
1. Reproduce with a minimal .lx test case
2. Add the failing test to tests/
3. Fix the bug in the relevant stage
4. Verify fix + no regressions
5. Commit with fix description

## Communication
- Receive tasks via `for-fleet/` bottles
- Send results via commits with [luma] prefix
- Report blockers to Oracle1 via bottle in vessel repo
