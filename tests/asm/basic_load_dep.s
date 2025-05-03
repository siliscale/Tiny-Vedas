    .globl   _start
    .section .text

_start:
    lbu       x1, .rodata
    beq      x1, x0, zombie
    .include "eot_sequence.s"

zombie:
    .include "eot_sequence.s"

    .section .rodata
    .word    0xDEADBEEF
