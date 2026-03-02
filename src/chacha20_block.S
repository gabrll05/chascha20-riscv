    .section .text
    .globl chacha20_block

# void chacha20_block(uint32_t *state)
# a0 = puntero al estado de 16 palabras (uint32_t state[16])
chacha20_block:

    # --------------------------------------------------
    # Copiar estado inicial a registros de trabajo
    # Usamos t0-t15 para las 16 palabras
    # state[0..15] → t0..t15
    # --------------------------------------------------
    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)
    lw t4, 16(a0)
    lw t5, 20(a0)
    lw t6, 24(a0)
    lw t7, 28(a0)
    lw t8, 32(a0)
    lw t9, 36(a0)
    lw t10, 40(a0)
    lw t11, 44(a0)
    lw t12, 48(a0)
    lw t13, 52(a0)
    lw t14, 56(a0)
    lw t15, 60(a0)

    # --------------------------------------------------
    # Loop de 10 iteraciones: cada iteración = columna + diagonal rounds
    # Nota: puedes expandir manualmente si no quieres usar bucles
    # --------------------------------------------------
    li t16, 10           # contador de rondas
1:
    # --- Column rounds ---
    # QR(0,4,8,12)
    mv a0, t0
    mv a1, t4
    mv a2, t8
    mv a3, t12
    call quarter_round
    mv t0, a0
    mv t4, a1
    mv t8, a2
    mv t12, a3

    # QR(1,5,9,13)
    mv a0, t1
    mv a1, t5
    mv a2, t9
    mv a3, t13
    call quarter_round
    mv t1, a0
    mv t5, a1
    mv t9, a2
    mv t13, a3

    # QR(2,6,10,14)
    mv a0, t2
    mv a1, t6
    mv a2, t10
    mv a3, t14
    call quarter_round
    mv t2, a0
    mv t6, a1
    mv t10, a2
    mv t14, a3

    # QR(3,7,11,15)
    mv a0, t3
    mv a1, t7
    mv a2, t11
    mv a3, t15
    call quarter_round
    mv t3, a0
    mv t7, a1
    mv t11, a2
    mv t15, a3

    # --- Diagonal rounds ---
    # QR(0,5,10,15)
    mv a0, t0
    mv a1, t5
    mv a2, t10
    mv a3, t15
    call quarter_round
    mv t0, a0
    mv t5, a1
    mv t10, a2
    mv t15, a3

    # QR(1,6,11,12)
    mv a0, t1
    mv a1, t6
    mv a2, t11
    mv a3, t12
    call quarter_round
    mv t1, a0
    mv t6, a1
    mv t11, a2
    mv t12, a3

    # QR(2,7,8,13)
    mv a0, t2
    mv a1, t7
    mv a2, t8
    mv a3, t13
    call quarter_round
    mv t2, a0
    mv t7, a1
    mv t8, a2
    mv t13, a3

    # QR(3,4,9,14)
    mv a0, t3
    mv a1, t4
    mv a2, t9
    mv a3, t14
    call quarter_round
    mv t3, a0
    mv t4, a1
    mv t9, a2
    mv t14, a3

    # Decrementar contador de rondas
    addi t16, t16, -1
    bnez t16, 1b

    # --------------------------------------------------
    # Suma final con estado inicial
    # working_state[i] += state[i] (mod 2^32)
    # --------------------------------------------------
    lw t17, 0(a0)
    add t0, t0, t17
    lw t17, 4(a0)
    add t1, t1, t17
    lw t17, 8(a0)
    add t2, t2, t17
    lw t17, 12(a0)
    add t3, t3, t17
    lw t17, 16(a0)
    add t4, t4, t17
    lw t17, 20(a0)
    add t5, t5, t17
    lw t17, 24(a0)
    add t6, t6, t17
    lw t17, 28(a0)
    add t7, t7, t17
    lw t17, 32(a0)
    add t8, t8, t17
    lw t17, 36(a0)
    add t9, t9, t17
    lw t17, 40(a0)
    add t10, t10, t17
    lw t17, 44(a0)
    add t11, t11, t17
    lw t17, 48(a0)
    add t12, t12, t17
    lw t17, 52(a0)
    add t13, t13, t17
    lw t17, 56(a0)
    add t14, t14, t17
    lw t17, 60(a0)
    add t15, t15, t17

    # --------------------------------------------------
    # Guardar resultado en memoria
    # --------------------------------------------------
    sw t0, 0(a0)
    sw t1, 4(a0)
    sw t2, 8(a0)
    sw t3, 12(a0)
    sw t4, 16(a0)
    sw t5, 20(a0)
    sw t6, 24(a0)
    sw t7, 28(a0)
    sw t8, 32(a0)
    sw t9, 36(a0)
    sw t10, 40(a0)
    sw t11, 44(a0)
    sw t12, 48(a0)
    sw t13, 52(a0)
    sw t14, 56(a0)
    sw t15, 60(a0)

    ret