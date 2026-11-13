#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace
# del laboratorio, instala helm si no viene y coloca los archivos del lab en /root/lab.
#
# Los archivos llegan "aplanados" a /opt/lab12: en el nombre, "__" hace de "/" a partir de /root
# (lab__helm__saludo__templates__deployment.yaml -> /root/lab/helm/saludo/templates/deployment.yaml).
ESPERADOS=8
HELM_VERSION=v3.19.0

reintenta() { for i in 1 2 3 4 5; do "$@" && return 0; sleep 5; done; return 1; }

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-12 --dry-run=client -o yaml | kubectl apply -f -

# helm, si no viene instalado
if ! command -v helm >/dev/null 2>&1; then
  reintenta curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tgz
  tar -xzf /tmp/helm.tgz -C /tmp linux-amd64/helm && install -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm
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
