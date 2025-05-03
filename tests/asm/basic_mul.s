    .globl   _start
    .section .text

_start:
    li       x1, 0xdeadbeef
    li       x2, 0xfeadbeef
    mul      x3, x1, x2
    mulh     x4, x1, x2
    mulhsu   x5, x1, x2
    mulhu    x6, x1, x2
    nop
    nop
    nop
    nop
    nop
    .include "eot_sequence.s"
