#!/bin/bash
# La imagen localhost/kcna-web:multi existe y su pagina viene de la etapa build.
podman image exists localhost/kcna-web:multi \
  || { echo "Falta la imagen localhost/kcna-web:multi: construyela con -f Containerfile.multistage"; exit 1; }
podman run --rm localhost/kcna-web:multi cat /usr/share/nginx/html/index.html 2>/dev/null | grep -q 'Generado en la etapa build' \
  || { echo "La pagina de kcna-web:multi no es la generada en la etapa build"; exit 1; }
