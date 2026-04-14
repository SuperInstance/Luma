# TASK-BOARD — Luma

## Priority 1: Fleet Integration
- [ ] Add CHARTER/STATE/IDENTITY/ABSTRACTION/DOCKSIDE-EXAM to repo root
- [ ] Set up CI workflow for automated testing on PR
- [ ] Add `for-fleet/` directory for bottle-based communication
- [ ] Cross-compile for ARM64 (Jetson) and verify tests pass

## Priority 2: Compiler Improvements
- [ ] Add generic type support to type checker
- [ ] Implement pattern matching in parser
- [ ] Add error recovery in lexer (continue after syntax error)
- [ ] Support cross-compilation targets (ARM64, RISC-V, WASM)
- [ ] Add optimization passes to LLVM backend

## Priority 3: Testing
- [ ] Write FLUX bytecode emission backend (Luma → FLUX ISA)
- [ ] Add property-based testing for parser
- [ ] Benchmark against GCC/Clang on same algorithms
- [ ] Add stress tests for arena allocator

## Priority 4: Documentation
- [ ] Write language specification document
- [ ] Add more examples (HTTP server, file I/O, threading)
- [ ] Document ownership annotation system (#takes_ownership, #returns_ownership)
- [ ] Write "Luma for C programmers" guide

## Priority 5: Fleet Tooling
- [ ] Build a FLUX runtime in Luma (eat your own dog food)
- [ ] Compile holodeck-c to Luma and benchmark
- [ ] Generate FLUX ISA opcodes from Luma type system
- [ ] Write a Cocapn agent in Luma

## Completed
- [x] Fork from Luma-Programming-Language/Luma
- [x] Agentify with CHARTER/STATE/IDENTITY
