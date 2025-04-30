.globl _start
.section .text

_start:
    li x1, 0xFFFFFFFF
    li x2, 0xFFFFFFFE
    sub x3, x1, x2
    .include "eot_sequence.s"

