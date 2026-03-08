typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

extern void chacha20_encrypt(uint32_t *state, uint8_t *in, uint8_t *out, uint32_t len);

// Esta es nuestra trampa. Le decimos al compilador que NO la optimice.
// Cuando GDB se detenga aquí, el registro 'a0' tendrá el puntero exacto.
void __attribute__((noinline, optimize("O0"))) stop_here(volatile uint8_t *ptr) {
    while(1); 
}

int main() {
    volatile uint32_t original_state[16] = {
        0x61707865,0x3320646e,0x79622d32,0x6b206574,
        0x03020100,0x07060504,0x0b0a0908,0x0f0e0d0c,
        0x13121110,0x17161514,0x1b1a1918,0x1f1e1d1c,
        0x00000001,0x09000000,0x4a000000,0x00000000
    };

    volatile uint32_t state_encrypt[16];
    volatile uint32_t state_decrypt[16];

    for(int i = 0; i < 16; i++) {
        state_encrypt[i] = original_state[i];
        state_decrypt[i] = original_state[i];
    }

    volatile uint8_t plaintext[140] = "Este es un mensaje de prueba super secreto que tiene mas de ciento veintiocho bytes para poder evaluar el incremento del contador !!!";
    volatile uint8_t ciphertext[140];
    volatile uint8_t decrypted[140];

    // 1. Ciframos
    chacha20_encrypt((uint32_t*)state_encrypt, (uint8_t*)plaintext, (uint8_t*)ciphertext, 140);
    
    // 2. Desciframos
    chacha20_encrypt((uint32_t*)state_decrypt, (uint8_t*)ciphertext, (uint8_t*)decrypted, 140);

    // 3. ¡Atrapamos el resultado y nos detenemos!
    stop_here(decrypted);

    return 0;
}