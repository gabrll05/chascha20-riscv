    .section .data
# Estado inicial de 16 palabras (4x4) del RFC 8439 – Apéndice A.2
state:
    .word 0x61707865, 0x3320646e, 0x79622d32, 0x6b206574  # constantes "expand 32-byte k"
    .word 0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c  # clave
    .word 0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c  # clave
    .word 0x00000001, 0x09000000, 0x4a000000, 0x00000000  # contador + nonce

    .section .text
    .globl chacha20_block   # asegurarse de que el linker vea la función
    .extern quarter_round   # si usas quarter_round

# función chacha20_block permanece aquí
# sin _start