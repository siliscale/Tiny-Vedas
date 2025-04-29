.globl _start
.section .text

_start:
    li x1, 0xdeadbeef
    li x2, 0xfeadbeef
    li x3, 0x2
    add x31, x1, x3
    slt x30, x1, x2
    sltu x29, x1, x2
    xor x28, x1, x2
    or x27, x1, x2
    and x26, x1, x2
    sll x25, x1, x3
    srl x24, x1, x3
    sra x24, x1, x3
    ret
