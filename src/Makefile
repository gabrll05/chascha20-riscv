CC = riscv64-unknown-elf-gcc

CFLAGS = -O2 -march=rv64imac -mabi=lp64 -nostdlib -static

SRC = start.S main.c chacha20_block.S quarter_round.S

OUT = chacha

all:
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

run:
	qemu-riscv64 $(OUT)
	echo $$?

clean:
	rm -f $(OUT) *.o