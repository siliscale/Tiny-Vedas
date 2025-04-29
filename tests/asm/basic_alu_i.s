.globl _start
.section .text

_start:
    li x1, 0xdeadbeef
    li x2, 0xfeadbeef
    addi x31, x1, 0x1
    slti x30, x1, 0x1
    sltiu x29, x1, 0x1
    xori x28, x1, 0x0ff
    ori x27, x1, 0x0ff
    andi x26, x1, 0x00f
    slli x25, x1, 0x4
    srli x24, x1, 0x4
    srai x24, x1, 0x4
    ret
