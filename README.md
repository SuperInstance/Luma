# Luma

<p align="center">
  <img src="assets/luma.png" alt="Luma Logo" width="160"/>
</p>

> A modern systems programming language with manual memory control, static ownership analysis, LLVM code generation, and zero runtime overhead.

---

## Overview

**Luma** is a low-level compiled programming language that provides C-level performance and transparency with stronger compile-time tooling — no borrow checker, no lifetimes, no garbage collector. Designed for developers who need direct hardware access, predictable performance, and tiny binaries, Luma compiles through LLVM to native machine code with sub-100ms build times.

Luma is intentionally **memory-unsafe by design** but performs ownership-aware static analysis to catch common error patterns (use-after-free, double-free, unfreed allocations) *before* code generation — at zero runtime cost. Developers use lightweight annotations like `#returns_ownership` and `#takes_ownership` to make ownership transfers explicit where needed.

The language uses `.lx` source files and targets the **Plane 0 (Metal)** abstraction level — compiling directly to native machine code via LLVM with no runtime, no VM, and no hidden semantics.

---

## Architecture

Luma's compiler follows a classic multi-pass architecture implemented in clean C:

```
.lx Source
    │
    ▼
┌──────────────┐
│    Lexer      │  src/lexer/         — Tokenization of .lx source files
└──────┬───────┘
       ▼
┌──────────────┐
│    Parser     │  src/parser/        — Recursive descent → AST
└──────┬───────┘
       ▼
┌──────────────┐
│  Type Checker │  src/typechecker/   — Static analysis + ownership verification
└──────┬───────┘
       ▼
┌──────────────┐
│  LLVM Backend │  src/llvm/          — IR generation → native machine code
└──────┬───────┘
       ▼
   Native Binary
```

### Source Layout

```
src/
├── ast/              — Abstract syntax tree nodes and definitions
│   ├── ast.h / ast.c             — Core AST structures
│   ├── ast_utils.h / ast_utils.c — AST traversal and utilities
│   └── ast_definistions/         — Node type implementations (expr, stmt, type, preprocessor)
├── auto_docs/        — Automatic documentation generation from source
├── c_libs/           — C library bindings for the compiler itself
│   ├── memory/                   — Custom arena allocator
│   ├── error/                    — Error reporting infrastructure
│   ├── color/                    — Terminal color output
│   └── helper/                   — CLI argument parsing, path utilities
├── helper/           — CLI helpers (help text, run orchestration)
├── lexer/            — Lexical analysis (tokenization)
│   ├── lexer.h / lexer.c         — Token stream generation
├── parser/           — Syntax analysis (tokens → AST)
│   ├── parser.h / parser.c       — Entry point and statement parsing
│   ├── expr.c                    — Expression parsing (precedence climbing)
│   ├── stmt.c                    — Statement parsing
│   ├── type.c                    — Type declaration parsing
│   └── parser_utils.c            — Parser utility functions
├── typechecker/      — Static analysis and ownership verification
│   ├── type.h / type.c           — Type system core
│   ├── tc.c                      — Main typechecking entry point
│   ├── expr.c / stmt.c           — Expression and statement type checking
│   ├── scope.c                   — Scope management
│   ├── lookup.c                  — Symbol resolution
│   ├── module.c                  — Module-level analysis
│   ├── array.c                   — Array type checking
│   ├── error.c                   — Type error reporting
│   └── static_mem_tracker.c      — Ownership and memory lifecycle tracking
├── llvm/             — LLVM IR generation backend
│   ├── llvm.h                    — Backend interface
│   ├── core/llvm.c               — Main code generation entry
│   ├── core/lookup.c             — Symbol lookup during codegen
│   ├── types/type.c              — LLVM type mapping
│   ├── types/type_cache.c        — Type deduplication cache
│   ├── expr/                     — Expression code generation
│   │   ├── expr.c                — General expressions
│   │   ├── binary_ops.c          — Binary operator emission
│   │   ├── arrays.c              — Array operations
│   │   └── defer.c               — Defer statement lowering
│   ├── stmt/stmt.c               — Statement code generation
│   ├── struct/                   — Struct support
│   │   ├── struct.c              — Struct type emission
│   │   ├── struct_access.c       — Field access lowering
│   │   ├── struct_expr.c         — Struct literal construction
│   │   └── struct_helpers.c      — Struct utilities
│   ├── module/                   — Module code generation
│   │   ├── module_handles.c      — Module symbol resolution
│   │   └── member_access.c       — Cross-module member access
│   └── util/helpers.c            — LLVM utility functions
├── lsp/              — Language Server Protocol implementation
│   ├── lsp.h                     — LSP interface
│   ├── lsp_server.c              — Server lifecycle (stdio transport)
│   ├── lsp_message.c             — Message parsing and routing
│   ├── lsp_document.c            — Document synchronization
│   ├── lsp_diagnostics.c         — Error/warning diagnostics
│   ├── lsp_semantic_tokens.c     — Syntax highlighting
│   ├── lsp_symbols.c             — Symbol navigation
│   ├── lsp_module.c              — Module resolution
│   ├── lsp_json.c                — JSON-RPC helpers
│   ├── lsp_features.c            — Feature flags and capabilities
│   ├── formatter/                — Code formatting
│   │   ├── formatter.h / formatter.c
│   │   ├── expr.c / stmt.c       — Expression and statement formatting
│   ├── nvim-highliter/           — Neovim syntax highlighting
│   │   ├── luma.vim              — Vim syntax file
│   │   └── luma.lua              — Lua treesitter queries
│   └── language-support/         — VS Code extension
│       ├── syntaxes/luma.tmLanguage.json
│       ├── language-configuration.json
│       └── client/               — TypeScript extension source
└── main.c            — Compiler entry point
```

### Memory Model

Luma uses a **custom arena allocator** (`ArenaAllocator`) for its own internal memory management — 1MB initial size, linear allocation with bulk deallocation. This gives the compiler itself deterministic memory behavior while the *generated* code uses the explicit `alloc()`/`free()` model with static ownership tracking.

---

## Features

### Language Features
- **Manual memory management** with explicit `alloc()` / `free()` — you control every byte
- **Ownership-aware static analysis** — catches use-after-free, double-free, and memory leaks at compile time
- **Optional ownership annotations** — `#returns_ownership`, `#takes_ownership` for explicit transfer semantics
- **First-class structs and enums** — with member access, methods, and pattern matching
- **Module system** — `@module` declarations with `pub` visibility
- **Defer statements** — guaranteed cleanup at scope exit
- **Zero-cost abstractions** — no runtime, no garbage collector, no hidden allocations

### Compiler Features
- **Sub-100ms builds** for rapid iteration
- **LLVM 20.0+ backend** — native code generation for x86_64, ARM64, and more
- **Full LSP support** — diagnostics, go-to-definition, semantic tokens, symbol navigation
- **Built-in code formatter** — `luma --format` with check mode and in-place editing
- **VS Code extension** — syntax highlighting, language configuration, and editor integration
- **Neovim support** — Vim syntax file and treesitter queries included
- **Doxygen documentation** — auto-generated from source with `docs/` configuration
- **Nix reproducible builds** — `flake.nix` and `flake.lock` for hermetic environments
- **Cross-platform** — Linux, macOS, and Windows support via Make + autoconf

### Standard Library
- `std/io.lx` — Input/output operations
- `std/math.lx` — Mathematical functions and constants
- `std/memory.lx` — Memory allocation primitives
- `std/string.lx` — String manipulation
- `std/vector.lx` — Dynamic array implementation
- `std/time.lx` — Time and date utilities
- `std/arena.lx` — Arena allocator for generated programs
- `std/terminal.lx` / `std/termfx.lx` — Terminal effects and colors
- `std/args.lx` — Command-line argument parsing
- `std/sys.lx` — System calls and platform interfaces
- `std/win32.lx` — Windows API bindings
- `std/stl/stack.lx` — Stack data structure

---

## Build & Run

### Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| **GCC** | Any recent | C compiler for building Luma itself |
| **LLVM** | **20.0+** | Code generation backend |
| **Make** | GNU Make | Build automation |
| **Valgrind** | Optional | Memory debugging |

> **Critical:** LLVM 20.0+ is required. LLVM 19.1.x contains a regression causing `illegal hardware instruction` crashes during code generation.

### Quick Build

```bash
# Clone the repository
git clone https://github.com/SuperInstance/Luma
cd Luma

# Build the compiler
make

# Compile and run a Luma program
./luma build examples/hello.lx
./output
```

### Available Make Targets

| Target | Description |
|--------|-------------|
| `make` / `make all` | Build the `luma` compiler binary |
| `make debug` | Build with debug symbols (`-g`) |
| `make test` | Run basic smoke tests |
| `make llvm-test` | Test LLVM IR generation |
| `make view-ir` | Display generated LLVM IR |
| `make run-llvm` | Run generated bitcode with `lli` |
| `make compile-native` | Compile LLVM IR → assembly → native |
| `make clean` | Remove all build artifacts |
| `make help` | Show available targets |

### Code Formatting

```bash
# Format a file in-place
./luma --format file.lx

# Check formatting without modifying
./luma --format-check file.lx

# Format to stdout
./luma --format-stdout file.lx
```

### LSP Server

```bash
# Start the language server (stdio transport)
./luma --lsp
```

Configure your editor to use `luma --lsp` as the language server command for `.lx` files. VS Code extension and Neovim support are included in `src/lsp/`.

### Reproducible Build with Nix

```bash
# Enter the development shell
nix develop

# Build
make
```

### Installation Scripts

```bash
# Linux / macOS
bash scripts/install.sh

# Windows
scripts\install.bat
```

### Pre-built Releases

Pre-built binaries are available for Linux (x86_64) and Windows:
- [v0.1.0](releases/v0-1-0/) — Initial release
- [v0.1.2](releases/v0-1-2/) — Bug fixes and improvements
- [v0.1.6](releases/v0-1-6/) — Latest stable

---

## Integration

### As a Fleet Agent (Cocapn)

Luma is a **bootable git-agent** — the fleet's language specialist. It can be tasked via message-in-a-bottle and autonomously implements compiler work:

```bash
# Boot Luma as a fleet agent
git clone https://github.com/SuperInstance/Luma
cd Luma
bash boot_agent.sh "add generic type support to the type checker"
```

**Agent lifecycle:** Pull → Boot → Work → Learn → Push → Sleep

| Agent File | Purpose |
|------------|---------|
| `CHARTER.md` | Identity, mission, and specialization |
| `STATE.md` | Current capabilities and architecture |
| `TASK-BOARD.md` | 20+ assignable tasks |
| `SKILLS.md` | Compiler, codegen, and analysis capabilities |
| `BOOTCAMP.md` | Agent replacement training guide |
| `IDENTITY.md` | Agent personality and working style |
| `boot_agent.sh` | One-command boot script |

### FLUX Ecosystem Integration

Luma occupies **Plane 0 (Metal)** in the FLUX abstraction stack and serves as a primary toolchain component:

| Integration Point | Status |
|-------------------|--------|
| **flux-runtime** | Planned — FLUX ISA bytecode emission backend (`flux-emit`) |
| **Holodeck** | Planned — Compile holodeck room descriptions in Luma |
| **Cocapn agents** | Planned — Compile agent manifests in Luma |
| **Edge deployment** | Active — Cross-compiles for ARM64 (Jetson) and x86_64 (cloud) |
| **LSP ecosystem** | Active — Full language server for agent-assisted development |

### Why Luma for the Fleet

- **Replaces C in the toolchain** with cleaner syntax and identical performance
- **Static analysis catches bugs before deployment** — critical for edge devices where debugging is hard
- **Tiny binaries** — the 3D spinning cube demo compiles to just **24KB** in **51ms**
- **Cross-compilation** supports all fleet hardware targets (Pi, Jetson, ESP32)
- **LLVM backend** provides mature, well-optimized native code generation

---

## Example Programs

### Hello World

```luma
@module "hello"

pub const main = fn () int {
    output("Hello, World!\n");
    return 0;
}
```

### Ownership-Annotated Memory

```luma
@module "example"

#returns_ownership
fn create_buffer(size: int) *char {
    let buf: *char = alloc(size);
    return buf;
}

#takes_ownership
fn process_buffer(buf: *char) int {
    // Static analyzer verifies: buf is owned here, must be freed
    let result: int = do_work(buf);
    free(buf);
    return result;
}
```

### Real-World Tests

The `tests/` directory includes non-trivial programs that validate the full compiler pipeline:

| Test | Description |
|------|-------------|
| `tests/VM/` | A complete virtual machine written in Luma (lexer, parser, VM, debugger) |
| `tests/tetris/` | Fully playable Tetris game |
| `tests/rotating_cube/` | 3D graphics with sine/cosine lookup tables — 24KB binary, 51ms compile |
| `tests/chess_engine/` | Chess engine with piece and board modules |
| `tests/bubble_sort.lx` | Sorting algorithm benchmark |
| `tests/str_test.lx` | String library validation |
| `tests/mem_test.lx` | Memory management tests |
| `tests/terminal_test.lx` | Terminal effects and color output |

---

## Project Status

**Current Phase:** Active Development (v0.1.6)

See [STATE.md](STATE.md) for the complete capability checklist and [docs/todo.md](docs/todo.md) for the development roadmap.

---

## Links

- **Source:** [github.com/TheDevConnor/Luma](https://github.com/TheDevConnor/Luma)
- **Fleet Fork:** [github.com/SuperInstance/Luma](https://github.com/SuperInstance/Luma)
- **Community:** [Discord](https://bit.ly/lux-discord)
- **Documentation:** [Doxygen-generated docs](https://luma-programming-language.github.io/Luma/)

---

<img src="callsign1.jpg" width="128" alt="callsign">
