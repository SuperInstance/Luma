# SKILLS — Luma

## Compiler Work
- **compile**: Build .lx source files to native executables
- **typecheck**: Run static analysis on source without codegen
- **format**: Format .lx source files to standard style
- **lsp**: Run language server for editor integration

## Code Generation
- **emit-llvm**: Generate LLVM IR from .lx source
- **emit-asm**: Generate assembly from .lx source
- **emit-obj**: Generate object files from .lx source
- **cross-compile**: Compile for ARM64, RISC-V, WASM targets

## Analysis
- **analyze**: Run static ownership analysis
- **bench**: Benchmark Luma-compiled code against GCC/Clang
- **disassemble**: Disassemble compiled output for inspection

## Fleet-Specific
- **flux-emit**: Generate FLUX ISA bytecode from Luma source (planned)
- **holodeck-compile**: Compile holodeck rooms in Luma (planned)
- **cocapn-compile**: Compile Cocapn agent in Luma (planned)

## How to Invoke
Luma is a vessel — assign tasks via TASK-BOARD.md or for-fleet/ bottles.
It reads the task, builds context, implements, tests, commits.
