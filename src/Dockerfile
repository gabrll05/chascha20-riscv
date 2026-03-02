# Usamos Ubuntu 22.04 como base
FROM ubuntu:22.04

# Evitamos preguntas interactivas en apt
ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos e instalamos todas las herramientas necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-riscv64-unknown-elf \
    binutils-riscv64-unknown-elf \
    qemu qemu-user qemu-user-static \
    make \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Creamos un workspace dentro del contenedor
WORKDIR /workspace

# Mantener el contenedor interactivo
CMD ["/bin/bash"]