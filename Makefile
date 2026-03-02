CC = riscv64-unknown-elf-gcc
CFLAGS = -nostdlib -static

SRC = src/start.S src/main.c src/quarter_round.S
OUT = chacha

all:
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

run:
	qemu-riscv64 $(OUT)
	echo $$?