.section .text
.globl chacha20_block
.extern quarter_round

# void chacha20_block(uint32_t *state)

chacha20_block:

    # =================================
    # 1. EL PRÓLOGO (AQUÍ SE AGREGA s0)
    # =================================
    # reservar espacio stack
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s1, 80(sp)
    sd s2, 72(sp)
    sd s0, 64(sp)    # <--- AQUI: Guardamos el registro s0 en el stack para no corromperlo

    mv s0, a0        # s0 = puntero al estado original

    # ---------------------------------
    # copiar state -> working state
    # ---------------------------------

    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)

    lw t4, 16(a0)
    lw t5, 20(a0)
    lw t6, 24(a0)
    lw s1, 28(a0)

    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)

    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    sw s1, 28(sp)

    lw t0, 32(a0)
    lw t1, 36(a0)
    lw t2, 40(a0)
    lw t3, 44(a0)

    lw t4, 48(a0)
    lw t5, 52(a0)
    lw t6, 56(a0)
    lw s1, 60(a0)

    sw t0, 32(sp)
    sw t1, 36(sp)
    sw t2, 40(sp)
    sw t3, 44(sp)

    sw t4, 48(sp)
    sw t5, 52(sp)
    sw t6, 56(sp)
    sw s1, 60(sp)

    # =================================
    # 10 DOUBLE ROUNDS
    # =================================

    li s2, 10

round_loop:

    # =================================
    # COLUMN ROUND
    # =================================

    # QR(0,4,8,12)
    addi a0, sp, 0
    addi a1, sp, 16
    addi a2, sp, 32
    addi a3, sp, 48
    call quarter_round

    # QR(1,5,9,13)
    addi a0, sp, 4
    addi a1, sp, 20
    addi a2, sp, 36
    addi a3, sp, 52
    call quarter_round

    # QR(2,6,10,14)
    addi a0, sp, 8
    addi a1, sp, 24
    addi a2, sp, 40
    addi a3, sp, 56
    call quarter_round

    # QR(3,7,11,15)
    addi a0, sp, 12
    addi a1, sp, 28
    addi a2, sp, 44
    addi a3, sp, 60
    call quarter_round

    # =================================
    # DIAGONAL ROUND
    # =================================

    # QR(0,5,10,15)
    addi a0, sp, 0
    addi a1, sp, 20
    addi a2, sp, 40
    addi a3, sp, 60
    call quarter_round

    # QR(1,6,11,12)
    addi a0, sp, 4
    addi a1, sp, 24
    addi a2, sp, 44
    addi a3, sp, 48
    call quarter_round

    # QR(2,7,8,13)
    addi a0, sp, 8
    addi a1, sp, 28
    addi a2, sp, 32
    addi a3, sp, 52
    call quarter_round

    # QR(3,4,9,14)
    addi a0, sp, 12
    addi a1, sp, 16
    addi a2, sp, 36
    addi a3, sp, 56
    call quarter_round

    # decrementar contador
    addi s2, s2, -1
    bnez s2, round_loop


    # =================================
    # FEEDFORWARD
    # working_state[i] += original_state[i]
    # =================================

    lw t0, 0(sp)
    lw t1, 0(s0)
    addw t0, t0, t1
    sw t0, 0(sp)

    lw t0, 4(sp)
    lw t1, 4(s0)
    addw t0, t0, t1
    sw t0, 4(sp)

    lw t0, 8(sp)
    lw t1, 8(s0)
    addw t0, t0, t1
    sw t0, 8(sp)

    lw t0, 12(sp)
    lw t1, 12(s0)
    addw t0, t0, t1
    sw t0, 12(sp)

    lw t0, 16(sp)
    lw t1, 16(s0)
    addw t0, t0, t1
    sw t0, 16(sp)

    lw t0, 20(sp)
    lw t1, 20(s0)
    addw t0, t0, t1
    sw t0, 20(sp)

    lw t0, 24(sp)
    lw t1, 24(s0)
    addw t0, t0, t1
    sw t0, 24(sp)

    lw t0, 28(sp)
    lw t1, 28(s0)
    addw t0, t0, t1
    sw t0, 28(sp)

    lw t0, 32(sp)
    lw t1, 32(s0)
    addw t0, t0, t1
    sw t0, 32(sp)

    lw t0, 36(sp)
    lw t1, 36(s0)
    addw t0, t0, t1
    sw t0, 36(sp)

    lw t0, 40(sp)
    lw t1, 40(s0)
    addw t0, t0, t1
    sw t0, 40(sp)

    lw t0, 44(sp)
    lw t1, 44(s0)
    addw t0, t0, t1
    sw t0, 44(sp)

    lw t0, 48(sp)
    lw t1, 48(s0)
    addw t0, t0, t1
    sw t0, 48(sp)

    lw t0, 52(sp)
    lw t1, 52(s0)
    addw t0, t0, t1
    sw t0, 52(sp)

    lw t0, 56(sp)
    lw t1, 56(s0)
    addw t0, t0, t1
    sw t0, 56(sp)

    lw t0, 60(sp)
    lw t1, 60(s0)
    addw t0, t0, t1
    sw t0, 60(sp)

    # =================================
    # copiar working state -> state
    # =================================

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)

    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    lw s1, 28(sp)

    sw t0, 0(s0)
    sw t1, 4(s0)
    sw t2, 8(s0)
    sw t3, 12(s0)

    sw t4, 16(s0)
    sw t5, 20(s0)
    sw t6, 24(s0)
    sw s1, 28(s0)

    lw t0, 32(sp)
    lw t1, 36(sp)
    lw t2, 40(sp)
    lw t3, 44(sp)

    lw t4, 48(sp)
    lw t5, 52(sp)
    lw t6, 56(sp)
    lw s1, 60(sp)

    sw t0, 32(s0)
    sw t1, 36(s0)
    sw t2, 40(s0)
    sw t3, 44(s0)

    sw t4, 48(s0)
    sw t5, 52(s0)
    sw t6, 56(s0)
    sw s1, 60(s0)

    # ---------------------------------
    # =================================
    # 2. EL EPÍLOGO (AQUÍ SE RESTAURA s0)
    # =================================

    ld s0, 64(sp)    # <--- AQUI: Restauramos el valor original de s0 antes de retornar
    ld s2, 72(sp)
    ld s1, 80(sp)
    ld ra, 88(sp)

    addi sp, sp, 96

    ret