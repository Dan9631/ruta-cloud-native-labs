#!/bin/bash
# El overlay dev se ha renderizado y guardado en /root/dev.yaml (este paso no cambia el cluster).
f=/root/dev.yaml
[ -s "$f" ] || { echo "Falta /root/dev.yaml: renderiza el overlay dev con kubectl kustomize ... | tee /root/dev.yaml"; exit 1; }
grep -q 'name: dev-web' "$f" && grep -q 'env: dev' "$f" && grep -q 'kind: Deployment' "$f" \
  || { echo "/root/dev.yaml no contiene el render del overlay dev (dev-web con env: dev)"; exit 1; }
