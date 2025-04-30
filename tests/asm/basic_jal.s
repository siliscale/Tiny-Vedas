.globl _start
.section .text

_start:
    jal x2, target
    nop
    nop
    nop

target:
    lui x1, 0x10
    .include "eot_sequence.s"
