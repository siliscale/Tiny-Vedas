.globl _start
.section .text

_start:
    li x1, 0xFFFFFFFF
    blt x1, x0, target
    li x1, 0xdeadbeef # Should not be executed

target:
    li x2, 0xFFFFFFFE
    blt x1, x2, zombie
    .include "eot_sequence.s"

zombie:
    .include "eot_sequence.s"
