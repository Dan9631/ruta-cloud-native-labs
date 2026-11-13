#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace,
# deja que el unico nodo ejecute Pods e instala Podman si no esta.
export DEBIAN_FRONTEND=noninteractive
APT="apt-get -o DPkg::Lock::Timeout=300"

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-01 --dry-run=client -o yaml | kubectl apply -f -

# controlplane es el unico nodo: si tiene el taint de plano de control, se quita para que acepte Pods.
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule- >/dev/null 2>&1 || true

# Podman para construir la imagen. Se instala crun de forma explicita para que apt no
# elija el paquete runc, que puede chocar con el containerd del nodo.
# jq sirve para leer el JSON de 'podman image inspect'.
if ! command -v podman >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  $APT update
  command -v podman >/dev/null 2>&1 || $APT install -y crun podman
  command -v jq >/dev/null 2>&1 || $APT install -y jq
fi

# Los nombres cortos (nginx:1.27-alpine) se buscan en Docker Hub, como en el curso.
mkdir -p /etc/containers/registries.conf.d
cat > /etc/containers/registries.conf.d/99-ruta-cloud-native.conf <<'EOF'
unqualified-search-registries = ["docker.io"]
EOF

# crictl debe hablar con containerd.
if [ ! -s /etc/crictl.yaml ]; then
  echo "runtime-endpoint: unix:///run/containerd/containerd.sock" > /etc/crictl.yaml
fi

# Imagen base para el build (con reintentos).
for i in 1 2 3 4 5; do podman pull -q docker.io/library/nginx:1.27-alpine && break; sleep 5; done

mkdir -p /root/lab/web
kubectl wait --for=condition=Ready node --all --timeout=300s
systemctl is-active --quiet containerd || echo "AVISO: containerd no esta activo tras preparar el escenario"
touch /tmp/listo
