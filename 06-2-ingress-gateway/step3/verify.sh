#!/bin/bash
# Un kubectl port-forward escucha en el puerto 9006 y llega a un Pod whoami.
curl -s --max-time 5 http://localhost:9006 | grep -q 'Hostname: whoami-' \
  || { echo "No hay un port-forward a svc/whoami escuchando en el puerto 9006"; exit 1; }
