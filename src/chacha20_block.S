    .section .text
    .globl chacha20_block

# void chacha20_block(uint32_t *state)
chacha20_block:
    addi sp, sp, -64        # reservar 16 palabras * 4 bytes
    sd ra, 56(sp)           # guardar ra
    mv s0, a0               # s0 = state

    # cargar estado en stack
    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)
    lw t4, 16(a0)
    lw t5, 20(a0)
    lw t6, 24(a0)
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)

    # últimas palabras usando s1–s5
    lw s1, 28(a0)
    lw s2, 32(a0)
    lw s3, 36(a0)
    lw s4, 40(a0)
    sw s1, 28(sp)
    sw s2, 32(sp)
    sw s3, 36(sp)
    sw s4, 40(sp)

    # punteros para quarter round
    addi a0, sp, 0
    addi a1, sp, 16
    addi a2, sp, 28
    addi a3, sp, 40
    call quarter_round

    # guardar de vuelta
    lw t0, 0(sp)
    lw t4, 16(sp)
    lw s1, 28(sp)
    lw s2, 40(sp)
    sw t0, 0(s0)
    sw t4, 16(s0)
    sw s1, 28(s0)
    sw s2, 40(s0)

    ld ra, 56(sp)
    addi sp, sp, 64
    ret