typedef unsigned int uint32_t;

extern void chacha20_block(uint32_t *state);

int main() {

    uint32_t state[16] = {
        0,1,2,3,
        4,5,6,7,
        8,9,10,11,
        12,13,14,15
    };

    chacha20_block(state);

    // comprobar que el estado cambió
    if (state[0] == 0 &&
        state[1] == 1 &&
        state[2] == 2 &&
        state[3] == 3)
    {
        return 1; // fallo
    }

    return 0; // éxito
}