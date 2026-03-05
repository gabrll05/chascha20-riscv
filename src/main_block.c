typedef unsigned int uint32_t;

extern void chacha20_block(uint32_t *state);

int main() {

    uint32_t state[16] = {
        0x61707865,0x3320646e,0x79622d32,0x6b206574,
        0x03020100,0x07060504,0x0b0a0908,0x0f0e0d0c,
        0x13121110,0x17161514,0x1b1a1918,0x1f1e1d1c,
        0x00000001,0x09000000,0x4a000000,0x00000000
    };

    chacha20_block(state);

    return state[0] & 0xff;
}