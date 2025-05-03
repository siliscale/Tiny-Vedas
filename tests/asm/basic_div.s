    .globl   _start
    .section .text

_start:
    li       x1, 0xdeadbeef
    li       x2, 0x2
    div      x3, x1, x2
    mv       x4, x3
    nop
    nop
    nop
    nop
    nop
    .include "eot_sequence.s"
