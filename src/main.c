typedef unsigned int uint32_t;

// Nombre actualizado según la especificación
extern void quarter_round(uint32_t*, uint32_t*, uint32_t*, uint32_t*);

int main() {
    uint32_t a = 0x11111111;
    uint32_t b = 0x01020304;
    uint32_t c = 0x9b8d6f43;
    uint32_t d = 0x01234567;

    quarter_round(&a, &b, &c, &d);

    if (a == 0xea2a92f4 &&
        b == 0xcb1cf8ce &&
        c == 0x4581472e &&
        d == 0x5881c4bb)
        return 0; // 0 significa éxito en bash

    return 1; // 1 significa error
}