#!/bin/bash
# web1 tiene /tmp/nota.txt en su propio filesystem y la maquina no lo tiene.
nota=$(podman exec web1 cat /tmp/nota.txt 2>/dev/null)
echo "$nota" | grep -q 'hola' \
  || { echo "Falta /tmp/nota.txt con el texto 'hola' dentro del contenedor web1"; exit 1; }
[ ! -e /tmp/nota.txt ] \
  || { echo "/tmp/nota.txt existe en la maquina: escribelo dentro del contenedor con podman exec"; exit 1; }
