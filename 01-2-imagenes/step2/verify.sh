#!/bin/bash
# El contenedor web2 corre la imagen propia, sirve la pagina v1 en el 8082 y tiene KCNA_MODULO=01.
img=$(podman inspect web2 --format '{{.State.Status}} {{.ImageName}}' 2>/dev/null)
[ "$img" = "running localhost/kcna-web:1.0" ] \
  || { echo "Falta el contenedor web2 en marcha con la imagen kcna-web:1.0 (ahora: '$img')"; exit 1; }
curl -sf http://localhost:8082 | grep -q 'KCNA v1' \
  || { echo "web2 no sirve tu pagina en http://localhost:8082: revisa el -p 8082:80"; exit 1; }
[ "$(podman exec web2 printenv KCNA_MODULO 2>/dev/null)" = "01" ] \
  || { echo "La variable KCNA_MODULO no vale 01 dentro de web2"; exit 1; }
