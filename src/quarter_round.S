.section .text
.globl quarter_round

    quarter_round:
    # cargar valores desde memoria (32 bits)
    lw t0, 0(a0)      # t0 = *a
    lw t1, 0(a1)      # t1 = *b
    lw t2, 0(a2)      # t2 = *c
    lw t3, 0(a3)      # t3 = *d

    # --- step 1: a += b; d ^= a; d = ROTL(d,16) ---
    addw t0, t0, t1
    xor t3, t3, t0
    slliw t4, t3, 16
    srliw t5, t3, 16
    or t3, t4, t5

    # --- step 2: c += d; b ^= c; b = ROTL(b,12) ---
    addw t2, t2, t3
    xor t1, t1, t2
    slliw t4, t1, 12
    srliw t5, t1, 20
    or t1, t4, t5

    # --- step 3: a += b; d ^= a; d = ROTL(d,8) ---
    addw t0, t0, t1
    xor t3, t3, t0
    slliw t4, t3, 8
    srliw t5, t3, 24
    or t3, t4, t5

    # --- step 4: c += d; b ^= c; b = ROTL(b,7) ---
    addw t2, t2, t3
    xor t1, t1, t2
    slliw t4, t1, 7
    srliw t5, t1, 25
    or t1, t4, t5

    # guardar resultados en memoria
    sw t0, 0(a0)
    sw t1, 0(a1)
    sw t2, 0(a2)
    sw t3, 0(a3)

    ret