#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace
# del laboratorio, instala git si no viene y coloca los archivos del lab en /root/lab
# (y la solucion del reto en /root/solucion). Argo CD lo instala el alumno en el paso 1.
#
# Los archivos llegan "aplanados" a /opt/lab12: en el nombre, "__" hace de "/" a partir de /root
# (lab__gitops__repo__deployment.yaml -> /root/lab/gitops/repo/deployment.yaml).
ESPERADOS=9

reintenta() { for i in 1 2 3 4 5; do "$@" && return 0; sleep 5; done; return 1; }

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-12 --dry-run=client -o yaml | kubectl apply -f -

# git (cliente) para clonar y hacer push al servidor Git del cluster
if ! command -v git >/dev/null 2>&1; then
  reintenta apt-get update -q
  reintenta env DEBIAN_FRONTEND=noninteractive apt-get install -y -q git
fi

for i in $(seq 1 120); do
  [ "$(ls -1 /opt/lab12 2>/dev/null | wc -l)" -ge "$ESPERADOS" ] && break
  sleep 1
done
for f in /opt/lab12/*; do
  n=$(basename "$f")
  install -D -m 0644 "$f" "/root/${n//__//}"
done

touch /tmp/listo
