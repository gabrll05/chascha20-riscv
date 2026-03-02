.section .text
.globl _start
.extern main

_start:
    call main
    li a7, 93      # syscall exit
    ecall