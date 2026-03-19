# Implementación de ChaCha20 en Ensamblador RISC-V

## Descripción del Proyecto
Este proyecto implementa el algoritmo de cifrado de flujo ChaCha20 en ensamblador RISC-V de 64 bits (bare-metal), orquestado por un programa en C. Cumple con la especificación del RFC 8439, generando bloques de *keystream* mediante operaciones de *quarter round* e incrementando el contador para procesar múltiples bloques de datos mediante la operación XOR.

## Estructura del Repositorio
```text
.
├── src/
│   ├── main.c               # Orquestador, definición de estado y pruebas
│   ├── quarter_round.S      # Función principal de amasado (4 palabras)
│   ├── chacha20_block.S     # Generador de bloque de 64 bytes (20 rondas)
│   ├── chacha20_encrypt.S   # Bucle de cifrado multi-bloque y XOR
│   ├── syscalls.S           # Driver personalizado para prints (Syscall 64)
│   ├── start.S              # Código de inicio bare-metal (opcional/QEMU)
│   └── Makefile             # Reglas de compilación y enlace
└── README.md                # Este manual
└── DOCUMENTACION.md         # Documentación técnica y bitácora