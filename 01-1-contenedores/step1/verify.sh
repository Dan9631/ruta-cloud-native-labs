#!/bin/bash
# El contenedor web1 (nginx:1.27-alpine) esta en marcha, responde en el 8081 y su log tiene al menos una peticion.
estado=$(podman inspect web1 --format '{{.State.Status}} {{.ImageName}}' 2>/dev/null)
[ "$estado" = "running docker.io/library/nginx:1.27-alpine" ] \
  || { echo "Falta el contenedor web1 en marcha con nginx:1.27-alpine (ahora: '$estado')"; exit 1; }
curl -sf http://localhost:8081 | grep -q 'Welcome to nginx' \
  || { echo "web1 no responde en http://localhost:8081: revisa el -p 8081:80"; exit 1; }
podman logs web1 2>&1 | grep -q '"GET / HTTP' \
  || { echo "El log de web1 no tiene ninguna peticion: ejecuta el curl"; exit 1; }
