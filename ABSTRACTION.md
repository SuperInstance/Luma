# ABSTRACTION — Luma

## Primary Plane
Plane 0 (Metal) — compiles to native code via LLVM

## Secondary Plane
Plane 1 (Native) — C implementation with manual memory management

## Rationale
Luma is a systems language that targets bare metal. It compiles through LLVM to
native machine code. No runtime, no garbage collector, no virtual machine.
The type checker performs static analysis at compile time, but the output is raw metal.

## Fleet Value
- Can replace C in fleet toolchain (cleaner syntax, same performance)
- Static analysis catches bugs before deployment (critical for edge devices)
- LSP enables agent-assisted development
- Cross-compilation supports all fleet hardware (Pi, Jetson, ESP32)
