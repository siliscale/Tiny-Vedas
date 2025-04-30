.globl _start
.section .text

_start:
    jal x3, target
    .include "eot_sequence.s"

target:
    li x4, 0x00100000
    jalr x0, x3, 0
