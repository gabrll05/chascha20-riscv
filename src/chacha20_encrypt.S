.section .text
.globl chacha20_encrypt
.extern chacha20_block

chacha20_encrypt:
    # Prólogo blindado: 256 bytes
    addi sp, sp, -256
    sd ra, 232(sp)
    sd a0, 200(sp)   # Estado
    sd a1, 208(sp)   # IN
    sd a2, 216(sp)   # OUT
    sd a3, 224(sp)   # LEN

encrypt_loop:
    ld a3, 224(sp)
    beqz a3, encrypt_end

    # 1. Copiar estado al buffer local (0(sp) a 63(sp))
    ld t0, 200(sp)
    li t1, 0
copy_loop:
    slli t2, t1, 2
    add t3, t0, t2
    lw t4, 0(t3)
    add t5, sp, t2
    sw t4, 0(t5)
    addi t1, t1, 1
    li t6, 16
    blt t1, t6, copy_loop

    # 2. Llamar a block
    mv a0, sp
    call chacha20_block

    # 3. Bucle XOR
    li t0, 0
xor_loop:
    ld a3, 224(sp)
    beqz a3, inc_counter
    li t1, 64
    beq t0, t1, inc_counter

    # Cargar IN
    ld t2, 208(sp)
    add t3, t2, t0
    lbu t4, 0(t3)

    # Cargar Keystream
    add t5, sp, t0
    lbu t6, 0(t5)

    # XOR
    xor t4, t4, t6

    # Guardar OUT
    ld t2, 216(sp)
    add t3, t2, t0
    sb t4, 0(t3)

    addi t0, t0, 1

    addi a3, a3, -1
    sd a3, 224(sp)
    j xor_loop

inc_counter:
    # Actualizar punteros
    ld t2, 208(sp)
    add t2, t2, t0
    sd t2, 208(sp)

    ld t2, 216(sp)
    add t2, t2, t0
    sd t2, 216(sp)

    # Incrementar contador (Palabra 12 = 48 bytes)
    ld t2, 200(sp)
    lw t3, 48(t2)
    addi t3, t3, 1
    sw t3, 48(t2)

    j encrypt_loop

encrypt_end:
    # Epílogo
    ld ra, 232(sp)
    addi sp, sp, 256
    ret