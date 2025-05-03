    .globl   _start
    .section .text

_start:
    lw       x1, 0(x0)
    lw       x2, 1(x0)
    lw       x3, 2(x0)
    lw       x4, 3(x0)
    lb       x1, 0(x0)
    lb       x2, 1(x0)
    lb       x3, 2(x0)
    lb       x4, 3(x0)
    lh       x1, 0(x0)
    lh       x2, 1(x0)
    lh       x3, 2(x0)
    lh       x4, 3(x0)
    .include "eot_sequence.s"
