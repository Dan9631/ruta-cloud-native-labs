#!/bin/bash
# El static pod de prueba se ha eliminado borrando su archivo en node01: el mirror pod ya no existe.
if kubectl get pod estatico-node01 -n lab-02 >/dev/null 2>&1; then
  echo "El Pod estatico-node01 sigue existiendo: borra /etc/kubernetes/manifests/estatico.yaml en node01 y espera unos segundos"
  exit 1
fi
