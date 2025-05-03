    .globl   printf
    .section .text

    .equ     MMIO_UART_ADDR, 0x200000

printf:
    li       t1, MMIO_UART_ADDR       # Get the memory-mapped UART address
    mv       t2, a0                   # Move the head of the string to a temporary register

printf_loop:
    lbu      t0, 0(t2)                # Load the byte pointed from t2
    beq      t0, zero, printf_exit    # If it's zero, it means we consumed the whole string
    sb       t0, 0(t1)                # else, store the byte to the UART
    addi     t2, t2, 1                # Get the next byte address
    j        printf_loop              # Cycle

printf_exit:
    ret
