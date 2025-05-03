    .globl   _start
    .section .text

_start:
    li       x1, 0xdeadbeef
    .include "eot_sequence.s"
