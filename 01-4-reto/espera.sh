echo "Preparando el laboratorio (puede tardar un par de minutos)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
if command -v podman >/dev/null 2>&1; then
  echo "Listo: namespace lab-01 creado y Podman instalado. Los archivos estan en /root/lab"
  podman --version
else
  echo "ERROR: Podman no esta disponible. Revisa /var/log/killercoda"
fi
kubectl get nodes
