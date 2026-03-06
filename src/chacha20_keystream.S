.section .text
.globl chacha20_keystream
.extern chacha20_block

# void chacha20_keystream(uint32_t *state, uint8_t *stream)
chacha20_keystream:
    # Prólogo
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)

    mv s0, a0      # s0 = estado original
    mv s1, a1      # s1 = buffer de salida (stream)

    # Copiar estado original al stack (working copy para block)
    li t0, 0
copy_loop:
    slli t1, t0, 2
    add t2, s0, t1
    lw t3, 0(t2)
    add t4, sp, t1
    sw t3, 0(t4)
    addi t0, t0, 1
    li t5, 16
    blt t0, t5, copy_loop

    # Llamar a chacha20_block pasando la copia (en sp)
    mv a0, sp
    call chacha20_block

    # chacha20_block ya hizo el feedforward (suma). 
    # El resultado de 64 bytes está ahora en el stack (sp).
    # Solo queda copiarlo al buffer de salida (stream en s1).
    li t0, 0
store_loop:
    slli t1, t0, 2
    add t2, sp, t1
    lw t3, 0(t2)     # Cargar del resultado
    add t4, s1, t1
    sw t3, 0(t4)     # Guardar en stream
    addi t0, t0, 1
    li t5, 16
    blt t0, t5, store_loop

    # Epílogo
    ld s1, 56(sp)
    ld s0, 64(sp)
    ld ra, 72(sp)
    addi sp, sp, 80
    ret