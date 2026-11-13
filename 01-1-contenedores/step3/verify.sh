#!/bin/bash
# El contenedor 'limitado' esta en marcha con memory.max=64 MiB y cpu.max=0.5 CPU.
mem=$(podman exec limitado cat /sys/fs/cgroup/memory.max 2>/dev/null)
cpu=$(podman exec limitado cat /sys/fs/cgroup/cpu.max 2>/dev/null)
[ "$mem/$cpu" = "67108864/50000 100000" ] \
  || { echo "Falta el contenedor 'limitado' en marcha con --memory 64m y --cpus 0.5 (ahora: '$mem/$cpu')"; exit 1; }
