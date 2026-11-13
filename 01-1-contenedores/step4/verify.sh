#!/bin/bash
# Los contenedores web1 y limitado ya no existen (ni en marcha ni parados).
for c in web1 limitado; do
  if podman container exists "$c"; then
    echo "El contenedor $c todavia existe: borralo con podman rm -f $c"; exit 1
  fi
done
