.section .text
.globl sys_write

# int sys_write(int fd, const void *buf, int count)
# a0 = File Descriptor (1 = Pantalla/stdout)
# a1 = Puntero al texto/buffer
# a2 = Cantidad de bytes a imprimir
sys_write:
    li a7, 64      # a7 = 64 es el código de Syscall para "write" en RISC-V
    ecall          # Llama al sistema operativo (o a QEMU en nuestro caso)
    ret