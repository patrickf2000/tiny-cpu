
## Tiny-CPU

This is a work-in-progress 16-bit RISC CPU written in VHDL. This is my first attempt at writing a CPU, so it will likely be pretty awful. At the time of writing, the decoder, register file, and part of the control unit are all working. This is entirely a learning project to help me learn more about computer architecture.

This project can be built using GHDL. Currently, most of the testing is done by manually looking at the waveforms in GtkWave.

### Instructions

This is all a draft at the moment, but these are the instructions I'm shooting to implement (the only one at the moment that works is `li` and `out`)

* `ld` -> Load memory to register
* `str` -> Store register contents to memory
* `mv` -> Move contents of one register to another
* `li` -> Load immediate value to register
* `add`
* `sub`
* `and`
* `or`
* `xor`
* `lsh` -> Left shift
* `rsh` -> Right shift
* `br/be/bne/bl/ble/bg/bge` -> The branching instructions. These will all use the RISC-V style of `<reg> <reg> <destination label>`.
* `out` -> A debug function to output register contents
* `hlt` -> Halts the CPU
* `nop` -> Guess :)

As for the registers, there are 8 register- `r0` through `r7`. They are addressed using 3 bits.

### Encoding

All instructions are 16-bits long. Tiny-CPU is big-endian. There are two formats: 3-register instructions, and 2-register instructions.

Most instructions follow the 3-register instruction encoding: `[15:12 -> Opcode][11:9 -> Destination register][8:6 -> Source 2][5:3 -> Source 1][2:0 -> Funct]`

The 2-register encoding: `[15:12 -> Opcode][11:9 -> Destination register][8:0 -> Immediate or address]`

### Instruction encoding

The following is the encoding for each instruction:

* `nop` -> 0000
* `ld` -> 0001
* `str` -> 0010
* `mv` -> 0011
* `li` -> 0100
* `add/sub/and/or/xor/lsh/rsh` -> 0101 (The funct segment must be set)
* `br/be/bne/bl/ble/bg/bge` -> 0110 (The funct segment must be set)
* `out` -> 0111
* `hlt` -> 1000

The funct segment is a 3-bit number corresponding to the ALU and control-flow opcodes.

For the ALU, the funct codes are `000, 001, 010, 011, 100, 101, 110, 111` for `add, sub, and, or, xor, lsh, rsh` respectively.

For the control-flow, the funct codes are `000, 001, 010, 011, 100, 101, 110, 111` for `br, be, bne, bl, ble, bg, bge` respectively.

