    .globl   _start
    .section .text

_start:
    li       x1, 0xdeadbeef
    li       x2, 0xfeadbeef
    li       x3, 0x3
    mul      x4, x1, x2
    add      x4, x4, x3
    li       x5, 0xcafebabe
    li       x5, 0xdeadbeef
    li       x5, 0xcafebabe
    li       x5, 0xdeadbeef
    li       x5, 0xcafebabe
    nop
    nop
    nop
    nop
    nop
    .include "eot_sequence.s"
