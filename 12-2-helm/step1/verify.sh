#!/bin/bash
# El chart se ha renderizado en /root/saludo.yaml (este paso no cambia el cluster).
f=/root/saludo.yaml
[ -s "$f" ] || { echo "Falta /root/saludo.yaml: renderiza el chart con helm template saludo /root/lab/helm/saludo > /root/saludo.yaml"; exit 1; }
grep -q 'Hola desde Helm (v1)' "$f" && grep -q 'kind: Deployment' "$f" && grep -q 'name: saludo-html' "$f" \
  || { echo "/root/saludo.yaml no contiene el render del chart saludo (ConfigMap saludo-html y Deployment)"; exit 1; }
