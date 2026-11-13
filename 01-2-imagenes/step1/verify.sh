#!/bin/bash
# La imagen localhost/kcna-web:1.0 existe y lleva la etiqueta OCI de version 1.0.
podman image exists localhost/kcna-web:1.0 \
  || { echo "Falta la imagen localhost/kcna-web:1.0: ejecuta el podman build en /root/lab"; exit 1; }
v=$(podman image inspect localhost/kcna-web:1.0 --format '{{index .Labels "org.opencontainers.image.version"}}' 2>/dev/null)
[ "$v" = "1.0" ] \
  || { echo "La imagen no tiene la etiqueta org.opencontainers.image.version=1.0 (ahora: '$v')"; exit 1; }
