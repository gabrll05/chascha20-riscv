.section .text
.globl _start
.extern main

_start:

    call main        # ejecutar main

    # a0 ya contiene el return de main
    li a7, 93        # syscall exit
    ecall