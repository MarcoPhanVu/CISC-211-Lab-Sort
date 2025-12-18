Indexing Mode:


Indexing Modes:
Register to Register: MOV Rx, Ry

Absolute: LDR Rx, Memory => not available in ARM and RISC ISAs!

Literal(Immediate):
MOV R0, 15
ADD R1, R2, 12


Indexed, Base: LDR, [R1]



Only 1 CPU to use pure Harvard Architecture

x86-based CPUI use Von Neumann to connect CPU to main Memory
VN and H Architecture have more than 1 bus connecting CPU to memory

If a branch is taken:
Remaining instructions are flushedb And the pipeline must be refilled with new instructions

ADDSEQ R0, R1, R2 only executes when R1 == R2?
Execute ADD only if the Zero flag (Z) = 1

Access the 12th element (index 11) of a string array
Each char = 1 byte → offset = 11
LDRB r4, [r1, 11]

loads the 5th (index 4) character from the base address of a string already set in r10 into r5
LDRB r5, [r10, 4]

False: The ARM instruction set supports direct memory loads and stores (you can specify a label or address directly as an operand of a load or store instruction)
False: RISC programming models tend to have fewer registers than CISC models, and those registers often only work with certain instructions.
False:  ASR r0,r0,3 divides the contents of r0 by 2^3, or 8. However, to be mathematically correct, the contents of the register must be a signed 2s complement value.
False: The .data, .text, .equ and .word directives map to ARM instructions executed on the Cortex M4.
True: The LDR (super move) and NEG pseudo-instructions map to ARM instructions executed on the Cortex M4.

EORS r0,r0
LDR r0,=0x55555555
RORS r0, r0, 1
C = 1