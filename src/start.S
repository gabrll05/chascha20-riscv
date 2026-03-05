    .section .text
    .globl _start
    .extern main

_start:
    call main        # llamar a la función principal en C
    li a7, 93        # syscall exit
    ecall