CC = riscv64-unknown-elf-gcc
CFLAGS = -nostdlib -static

SRC = src/start.S src/main.c src/dummy.S
OUT = chacha

all:
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

run:
	qemu-riscv64 $(OUT)
	echo $$?