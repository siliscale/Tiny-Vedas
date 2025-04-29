.globl _start
.section .text

_start:
    li x1, 0xdeadbeef
    addi x1, x0, 0x2
    nop
    addi x2, x1, 0x1
    ret
