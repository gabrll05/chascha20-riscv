typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

extern void chacha20_encrypt(uint32_t *state, uint8_t *in, uint8_t *out, uint32_t len);

extern int sys_write(int fd, const void *buf, int count);

int string_len(const char *str) {
    int len = 0;
    while(str[len] != '\0') len++;
    return len;
}

void print_text(const char *label, const uint8_t *text, int len) {
    sys_write(1, label, string_len(label));
    sys_write(1, text, len);
    sys_write(1, "\n\n", 2);
}

// Función para imprimir datos en formato Hexadecimal (ORDENADO A 16 BYTES POR LÍNEA)
void print_hex(const char *label, const uint8_t *data, int len) {
    sys_write(1, label, string_len(label));
    
    char hex_chars[] = "0123456789abcdef";
    char buf[3];
    buf[2] = ' '; // Espacio entre números

    for(int i = 0; i < len; i++) {
        // Calcular los caracteres hexadecimales
        buf[0] = hex_chars[(data[i] >> 4) & 0x0F];
        buf[1] = hex_chars[data[i] & 0x0F];
        
        // Imprimir el byte (ej. "a5 ")
        sys_write(1, buf, 3);
        
        // Si ya imprimimos 16 bytes, hacemos un salto de línea
        if ((i + 1) % 16 == 0) {
            sys_write(1, "\n", 1);
        }
    }
    sys_write(1, "\n\n", 2);
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

    // --- IMPRIMIR ORIGINAL (Usamos cast para quitar el warning) ---
    print_text("--- TEXTO ORIGINAL ---\n", (const uint8_t *)plaintext, 139);

    // --- CIFRAR Y IMPRIMIR ---
    chacha20_encrypt((uint32_t*)state_encrypt, (uint8_t*)plaintext, (uint8_t*)ciphertext, 140);
    print_hex("--- TEXTO CIFRADO (HEX) ---\n", (const uint8_t *)ciphertext, 140);

    // --- DESCIFRAR Y IMPRIMIR ---
    chacha20_encrypt((uint32_t*)state_decrypt, (uint8_t*)ciphertext, (uint8_t*)decrypted, 140);
    print_text("--- TEXTO DESCIFRADO ---\n", (const uint8_t *)decrypted, 139);

    print_text("--- FIN DEL PROGRAMA ---\n", (const uint8_t *)"", 0);
    while(1); 
}