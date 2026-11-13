#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: deja Podman y jq listos y descarga las imagenes base.
export DEBIAN_FRONTEND=noninteractive
APT="apt-get -o DPkg::Lock::Timeout=300"

# Podman viene en la imagen ubuntu de Killercoda; jq sirve para leer el JSON de 'podman image inspect'.
if ! command -v podman >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  $APT update
  command -v podman >/dev/null 2>&1 || $APT install -y podman
  command -v jq >/dev/null 2>&1 || $APT install -y jq
fi

# Los nombres cortos (nginx:1.27-alpine) se buscan en Docker Hub, como en el curso.
mkdir -p /etc/containers/registries.conf.d
cat > /etc/containers/registries.conf.d/99-ruta-cloud-native.conf <<'EOF'
unqualified-search-registries = ["docker.io"]
EOF

# Imagenes base del laboratorio y la del registry del paso 3 (con reintentos).
for img in docker.io/library/nginx:1.27-alpine docker.io/library/busybox:1.37 docker.io/library/registry:2.8.3; do
  for i in 1 2 3 4 5; do podman pull -q "$img" && break; sleep 5; done
done

mkdir -p /root/lab/web
touch /tmp/listo
