    .globl   _start
    .section .text

_start:
    beq      x0, x0, target
    li       x1, 0xdeadbeef   # Should not be executed

target:
    lui      x1, 0x10
    beq      x0, x1, zombie
    .include "eot_sequence.s"

zombie:
    .include "eot_sequence.s"
