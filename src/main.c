typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

// Declaración de todas nuestras funciones en ensamblador
extern void quarter_round(uint32_t *a, uint32_t *b, uint32_t *c, uint32_t *d);
extern void chacha20_block(uint32_t *state);
extern void chacha20_encrypt(uint32_t *state, uint8_t *in, uint8_t *out, uint32_t len);

// Nuestro driver de Syscall
extern int sys_write(int fd, const void *buf, int count);

// Funciones auxiliares de impresión
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

void print_hex(const char *label, const uint8_t *data, int len) {
    sys_write(1, label, string_len(label));
    char hex_chars[] = "0123456789abcdef";
    char buf[3];
    buf[2] = ' '; 
    for(int i = 0; i < len; i++) {
        buf[0] = hex_chars[(data[i] >> 4) & 0x0F];
        buf[1] = hex_chars[data[i] & 0x0F];
        sys_write(1, buf, 3);
        if ((i + 1) % 16 == 0) sys_write(1, "\n", 1);
    }
    sys_write(1, "\n\n", 2);
}

// Nueva función para imprimir valores de 32 bits (para el Quarter Round)
void print_word(const char *label, uint32_t val) {
    sys_write(1, label, string_len(label));
    char hex_chars[] = "0123456789abcdef";
    char buf[8];
    for(int i = 7; i >= 0; i--) {
        buf[i] = hex_chars[val & 0x0F];
        val >>= 4;
    }
    sys_write(1, buf, 8);
    sys_write(1, "\n", 1);
}

int main() {
    // ====================================================================
    // PRUEBA 0: QUARTER ROUND AISLADO (Evaluación Punto 1 - RFC 8439)
    // ====================================================================
    print_text("=== PRUEBA 0: QUARTER ROUND (RFC 8439) ===\n", (const uint8_t *)"", 0);
    uint32_t a = 0x11111111;
    uint32_t b = 0x01020304;
    uint32_t c = 0x9b8d6f43;
    uint32_t d = 0x01234567;
    
    // Llamamos a la función in-place pasándole las direcciones de memoria
    quarter_round(&a, &b, &c, &d);
    
    // Debería imprimir: a=ea2a92f4, b=cb1cf8ce, c=4581472e, d=5881c4bb
    print_word("a = 0x", a);
    print_word("b = 0x", b);
    print_word("c = 0x", c);
    print_word("d = 0x", d);
    sys_write(1, "\n", 1);

    // ====================================================================
    // PREPARACION DEL ESTADO INICIAL (Clave y Nonce exactos del RFC 8439)
    // ====================================================================
    volatile uint32_t original_state[16] = {
        0x61707865,0x3320646e,0x79622d32,0x6b206574,
        0x03020100,0x07060504,0x0b0a0908,0x0f0e0d0c,
        0x13121110,0x17161514,0x1b1a1918,0x1f1e1d1c,
        0x00000001,0x09000000,0x4a000000,0x00000000
    };

    volatile uint32_t state_block[16];
    volatile uint32_t state_work_1[16]; 
    volatile uint32_t state_work_2[16];

    for(int i=0; i<16; i++) { 
        state_block[i] = original_state[i];
        state_work_1[i] = original_state[i]; 
        state_work_2[i] = original_state[i]; 
    }

    // ====================================================================
    // PRUEBA 1: BLOQUE CHACHA20 PURO (Evaluación Punto 2 - Keystream)
    // ====================================================================
    print_text("=== PRUEBA 1: KEYSTREAM DE 64 BYTES (RFC 8439) ===\n", (const uint8_t *)"", 0);
    chacha20_block((uint32_t*)state_block);
    print_hex("--- KEYSTREAM GENERADO ---\n", (const uint8_t *)state_block, 64);


    // ====================================================================
    // PRUEBA 2: CIFRADO RFC 8439 (Evaluación Punto 2 y Mostrar Texto)
    // ====================================================================
    volatile uint8_t rfc_plain[114] = "Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it.";
    volatile uint8_t rfc_cipher[114];
    volatile uint8_t rfc_decrypted[114];

    print_text("=== PRUEBA 2: CIFRADO RFC 8439 ===\n", (const uint8_t *)rfc_plain, 114);
    chacha20_encrypt((uint32_t*)state_work_1, (uint8_t*)rfc_plain, (uint8_t*)rfc_cipher, 114);
    print_hex("--- CIFRADO RFC ---\n", (const uint8_t *)rfc_cipher, 114);
    chacha20_encrypt((uint32_t*)state_work_2, (uint8_t*)rfc_cipher, (uint8_t*)rfc_decrypted, 114);
    print_text("--- DESCIFRADO RFC ---\n", (const uint8_t *)rfc_decrypted, 114);


    // ====================================================================
    // PRUEBA 3: MENSAJE > 128 BYTES (Evaluación Punto 3 y 4 - Multi-bloque)
    // ====================================================================
    // Restauramos el estado original para la última prueba
    for(int i=0; i<16; i++) { state_work_1[i] = original_state[i]; state_work_2[i] = original_state[i]; }

    volatile uint8_t long_plain[140] = "Este es un mensaje de prueba super secreto que tiene mas de ciento veintiocho bytes para poder evaluar el incremento del contador !!!";
    volatile uint8_t long_cipher[140];
    volatile uint8_t long_decrypted[140];

    print_text("=== PRUEBA 3: MENSAJE > 128 BYTES (3 Bloques) ===\n", (const uint8_t *)long_plain, 139);
    chacha20_encrypt((uint32_t*)state_work_1, (uint8_t*)long_plain, (uint8_t*)long_cipher, 140);
    print_hex("--- CIFRADO LARGO ---\n", (const uint8_t *)long_cipher, 140);
    chacha20_encrypt((uint32_t*)state_work_2, (uint8_t*)long_cipher, (uint8_t*)long_decrypted, 140);
    print_text("--- DESCIFRADO LARGO ---\n", (const uint8_t *)long_decrypted, 139);

    print_text("=== EJECUCION FINALIZADA CORRECTAMENTE ===\n", (const uint8_t *)"", 0);
    while(1); 
}