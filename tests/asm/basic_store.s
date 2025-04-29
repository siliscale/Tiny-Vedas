.globl _start
.section .text

_start:

    # Init Memory regions
    sw x0, 0(x0)
    sw x0, 4(x0)
    sw x0, 8(x0)
    sw x0, 12(x0)
    sw x0, 16(x0)
    sw x0, 20(x0)
    sw x0, 24(x0)

    li x1, 0xdeadbeef
    # Aligned, full-line stores
    sw x1, 0(x0)
    sw x1, 4(x0)
    lw x2, 0(x0)
    lw x3, 4(x0)
    
    # Byte stores
    li x31, 0xff
    sb x31, 4(x0)
    lw x2, 4(x0) 

    # Aligned, Halfword store
    li x31, 0xdead
    sh x31, 8(x0)
    lhu x2, 8(x0)
    sh x31, 10(x0)
    lw x2, 8(x0) 

    # Unaligned, Word Store
    li x31, 0xcafebabe
    sh x31, 12(x0)
    sw x31, 14(x0)
    lw x2,  12(x0)
    lw x2,  16(x0)
    ret
    