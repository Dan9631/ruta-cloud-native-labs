#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace
# del laboratorio y coloca los archivos del lab en /root/lab con sus subcarpetas.
#
# Los archivos llegan "aplanados" a /opt/lab12: en el nombre, "__" hace de "/" a partir de /root
# (lab__kustomize__base__deployment.yaml -> /root/lab/kustomize/base/deployment.yaml).
ESPERADOS=6

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-12 --dry-run=client -o yaml | kubectl apply -f -

for i in $(seq 1 120); do
  [ "$(ls -1 /opt/lab12 2>/dev/null | wc -l)" -ge "$ESPERADOS" ] && break
  sleep 1
done
for f in /opt/lab12/*; do
  n=$(basename "$f")
  install -D -m 0644 "$f" "/root/${n//__//}"
done

touch /tmp/listo
