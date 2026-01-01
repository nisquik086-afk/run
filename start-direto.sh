#!/bin/bash

# ===== CONFIGURAÇÕES DA VM =====
VM_NAME="winsmc"

IMG_FILE="$HOME/vms/winsmc/disk.qcow2"
SEED_FILE="$HOME/vms/winsmc/seed.img"

MEMORY="32000"      # MB
CPUS="8"

SSH_PORT="2222"

# ===== CHECAGENS =====
if [ ! -f "$IMG_FILE" ]; then
    echo "❌ Disco da VM não encontrado: $IMG_FILE"
    exit 1
fi

if [ ! -f "$SEED_FILE" ]; then
    echo "❌ Seed cloud-init não encontrado: $SEED_FILE"
    exit 1
fi

# ===== INICIANDO VM =====
echo "🚀 Iniciando VM: $VM_NAME"

exec qemu-system-x86_64 \
    -enable-kvm \
    -m "$MEMORY" \
    -smp "$CPUS" \
    -cpu host \
    -drive file="$IMG_FILE",format=qcow2,if=virtio \
    -drive file="$SEED_FILE",format=raw,if=virtio \
    -netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22 \
    -device virtio-net-pci,netdev=net0 \
    -nographic
