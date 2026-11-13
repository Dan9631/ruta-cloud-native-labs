#!/bin/bash
# El registry local responde en el 5000 y guarda kcna-web con el tag 1.0; web2 ya no existe.
if podman container exists web2; then
  echo "El contenedor web2 todavia existe: borralo con podman rm -f web2"; exit 1
fi
tags=$(curl -s --max-time 5 http://localhost:5000/v2/kcna-web/tags/list 2>/dev/null)
[ -n "$tags" ] || { echo "No responde ningun registry en http://localhost:5000: arranca el contenedor 'registry'"; exit 1; }
echo "$tags" | grep -q '"1.0"' \
  || { echo "El registry no tiene kcna-web:1.0: etiquetala como localhost:5000/kcna-web:1.0 y haz podman push (ahora: '$tags')"; exit 1; }
